namespace :mdvn do
  desc "Updates Journal from PubMed"
  task :journals => :environment do
    require 'pubmed_journal'
    require 'pp'
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
end
