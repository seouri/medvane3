namespace :mdvn do
  desc "Updates Journal from PubMed"
  task :journals => :environment do
    journal_ids = Journal.all(:select => :id).map {|j| j.id}
    journals = PubmedJournal.get
    journals.each do |j|
      unless journal_ids.include?(j[0].to_i)
        journal = Journal.new
        journal.id, journal.title, journal.abbr = j
        journal.save
      end
    end
  end

  desc "Updates Gene from PubMed"
  task :genes => :environment do
    # ftp://ftp.ncbi.nih.gov/gene/DATA/gene_info.gz
    # ftp://ftp.ncbi.nih.gov/gene/DATA/gene2pubmed.gz
  end
end
