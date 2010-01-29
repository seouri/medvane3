namespace :mdvn do
  desc "Updates Journal from PubMed"
  task :journals => :environment do
    journal_ids = Journal.all(:select => :id).map {|j| j.id}
    puts "[#{Time.now.to_s}] Journal.size = #{journal_ids.size}"
    journals = PubmedJournal.get
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

  def remigrate(version)
    ActiveRecord::Migrator.run(:down, "db/migrate/", version)
    ActiveRecord::Migrator.run(:up, "db/migrate/", version)
  end

  def download_gz(url)
    require 'open-uri'
    require 'zlib'
    Zlib::GzipReader.new(open(url))
  end

  namespace :genes do
    desc "Updates Gene and related models"
    task :all => :environment do
      ['published', 'gene', 'taxonomy'].each do |task|
        Rake::Task["mdvn:genes:#{task}"].invoke
      end
    end

    desc "Updates PublishedGene from PubMed"
    task :published => :environment do
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
      puts "[#{Time.now.to_s}] added: #{added}, failed: #{failed}"
    end

    desc "Updates Gene from PubMed"
    task :gene => :environment do
      puts "[#{Time.now.to_s}] recreate Gene"
      remigrate(20100128151156)

      puts "[#{Time.now.to_s}] downloading gene_info.gz"
      gz = download_gz('ftp://ftp.ncbi.nih.gov/gene/DATA/gene_info.gz')

      puts "[#{Time.now.to_s}] adding to Gene"
      added, failed = 0, 0
      gz.each_line do |line|
        taxonomy_id, gene_id, symbol, LocusTag, Synonyms, dbXrefs, chromosome, map_location, description, type_of_gene, Symbol_from_nomenclature_authority, Full_name_from_nomenclature_authority, Nomenclature_status, Other_designations, Modification_date = line.split(/\t/)
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
      puts "[#{Time.now.to_s}] added: #{added}, failed: #{failed}"
    end

    desc "Updates Taxonomy from PubMed"
    task :taxonomy => :environment do
      puts "[#{Time.now.to_s}] recreate Taxonomy"
      remigrate(20100128231533)

      puts "[#{Time.now.to_s}] downloading taxdump.tar.gz"
      gz = download_gz('ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz')
      
      puts "[#{Time.now.to_s}] adding to Gene"
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
  end
end
