namespace :mdvn do
  desc "Updates Journal from PubMed"
  task :journals => :environment do
    journal_ids = Journal.all(:select => :id).map {|j| j.id}
    puts "Journal.size = #{journal_ids.size}"
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
    puts "added: #{added}, failed: #{failed}"
  end

  desc "Updates Gene from PubMed"
  task :genes => :environment do
    # ftp://ftp.ncbi.nih.gov/gene/DATA/gene_info.gz
    # ftp://ftp.ncbi.nih.gov/gene/DATA/gene2pubmed.gz
  end
end
