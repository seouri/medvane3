class Bibliome < ActiveRecord::Base
  has_many :bibliome_articles, :order => "#{BibliomeArticle.table_name}.pubdate desc"
  has_many :articles, :through => :bibliome_articles
  has_many :journals, :class_name => "BibliomeJournal", :include => :journal
  has_many :authors, :class_name => "BibliomeAuthor", :include => :author
  has_many :subjects, :class_name => "BibliomeSubject", :include => :subject
  #has_many :genes, :class_name => "BibliomeGene", :include => :gene
  has_many :pubtypes, :class_name => "BibliomePubtype", :include => :pubtype
  has_many :author_journals
  has_many :coauthorships
  has_many :author_subjects
  has_many :author_pubtypes
  has_many :journal_subject
  has_many :journal_pubtypes
  has_many :cosubjects
  
  validates_uniqueness_of :name
  
  named_scope :built, :conditions => { :built => true }
  named_scope :recent, lambda {|limit|
    { :conditions => { :built => true }, :order => "built_at desc", :limit => limit }
  }
  named_scope :popular, lambda {|limit|
    { :conditions => { :built => true }, :order => "hits desc", :limit => limit }
  }
  named_scope :enqueued, :conditions => { :built => false, :articles_count => 0 }
  named_scope :inprocess, :conditions => "built=0 AND articles_count > 0"
  named_scope :last_built, :conditions => { :built => true }, :order => "built_at desc", :limit => 1

  def status
    if built?
      "finished importing"
    else
      "imported"
    end
  end

  def hit!
    if built?
      self.delete_at = 2.weeks.from_now
      self.increment! :hits
    end
  end

  def processing_time
    to_time = built_at || Time.now
    from_time = started_at || Time.now
    (to_time - from_time).round
  end

  def build_speed
    (articles_count.to_f / processing_time.to_f * 60).round.to_s + " articles/min"
  end
end
