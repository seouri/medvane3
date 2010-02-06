require 'open-uri'
require 'zlib'

module Medvane
  class Setup
    class << self
      def journals
        journal_ids = Journal.all(:select => :id).map {|j| j.id}
        puts "[#{Time.now.to_s}] Journal.size = #{journal_ids.size}"
        puts "[#{Time.now.to_s}] downloading jourcache.xml"
        journals = PubmedJournal.get
        
        puts "[#{Time.now.to_s}] add to Journal"
        added, failed = 0, 0
        journals.each do |j|
          unless journal_ids.include?(j[0].to_i)
            journal = Journal.new
            journal.id, journal.title, journal.abbr = j
            if journal.save
              puts "added #{j.join(" | ")}"
              added += 1
            else
              puts "failed to add #{j.join(" | ")}"
              failed += 1
            end
          end
        end
        puts "[#{Time.now.to_s}] added: #{added}, failed: #{failed}"
      end

      def genes
        puts "[#{Time.now.to_s}] removing index from Gene"
        migrate_down(20100131153724)
        puts "[#{Time.now.to_s}] recreate Gene"
        remigrate(20100128151156)

        puts "[#{Time.now.to_s}] downloading gene_info.gz"
        gz = download_gz('ftp://ftp.ncbi.nih.gov/gene/DATA/gene_info.gz')

        puts "[#{Time.now.to_s}] adding to Gene"
        added, failed = 0, 0
        gz.each_line do |line|
          taxonomy_id, gene_id, symbol, locusTag, synonyms, dbXrefs, chromosome, map_location, description, type_of_gene, symbol_from_nomenclature_authority, full_name_from_nomenclature_authority, nomenclature_status, other_designations, modification_date = line.split(/\t/)
          if gene_id
            g = Gene.new(:taxonomy_id => taxonomy_id, :symbol => symbol)
            g.id = gene_id
            if g.save!
              added += 1
            else
              failed += 1
            end
          end
        end
        puts "[#{Time.now.to_s}] adding index to Gene"
        migrate_up(20100131153724)

        puts "[#{Time.now.to_s}] added: #{added}, failed: #{failed}"
      end

      def published_genes
        puts "[#{Time.now.to_s}] removing index from PublishedGene"
        migrate_down(20100131153734)
        puts "[#{Time.now.to_s}] recreate PublishedGene"
        remigrate(20100127150217)

        puts "[#{Time.now.to_s}] downloading gene2pubmed.gz"
        gz = download_gz('ftp://ftp.ncbi.nih.gov/gene/DATA/gene2pubmed.gz')

        puts "[#{Time.now.to_s}] adding to PublishedGene"
        added, failed = 0, 0, 0
        gz.each_line do |line|
          tax_id, gene_id, article_id = line.strip.split(/\t/)
          pg = PublishedGene.new(:article_id => article_id, :gene_id => gene_id)
          if pg.save!
            added += 1
          else
            failed += 1
          end
        end
        puts "[#{Time.now.to_s}] adding index to PublishedGene"
        migrate_up(20100131153734)

        puts "[#{Time.now.to_s}] added: #{added}, failed: #{failed}"
      end

      def taxonomies
        puts "[#{Time.now.to_s}] recreate Taxonomy"
        remigrate(20100128231533)

        puts "[#{Time.now.to_s}] downloading taxdump.tar.gz"
        gz = download_gz('ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz')
    
        puts "[#{Time.now.to_s}] adding to Taxonomy"
        added, failed = 0, 0
        gz.each_line do |line|
          tax_id, name_txt, uniqu_name, name_class  = line.split(/\s*\|\s*/)
          if name_class == 'scientific name'
            t = Taxonomy.new(:name => name_txt)
            t.id = tax_id
            if t.save
              added += 1
            else
              failed += 1
            end
          end
        end
        puts "[#{Time.now.to_s}] added: #{added}, failed: #{failed}"
      end

      private
  
      def migrate_down(version)
        ActiveRecord::Migrator.run(:down, "db/migrate/", version) if ActiveRecord::Migrator.get_all_versions.include?(version)
      end

      def migrate_up(version)
        ActiveRecord::Migrator.run(:up, "db/migrate/", version)
      end

      def remigrate(version)
        migrate_down(version)
        migrate_up(version)
      end

      def download_gz(url)
        Zlib::GzipReader.new(open(url))
      end
    end
  end
end
