# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100131153734) do

  create_table "article_types", :force => true do |t|
    t.integer "article_id"
    t.integer "pubtype_id"
  end

  add_index "article_types", ["article_id"], :name => "index_article_types_on_article_id"

  create_table "articles", :force => true do |t|
    t.integer "journal_id"
    t.date    "pubdate"
    t.text    "title"
    t.text    "affiliation"
    t.string  "source"
    t.integer "bibliomes_count", :default => 0
  end

  add_index "articles", ["journal_id", "pubdate"], :name => "index_articles_on_journal_id_and_pubdate"
  add_index "articles", ["pubdate"], :name => "index_articles_on_pubdate"

  create_table "author_journals", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "author_id"
    t.integer "journal_id"
    t.string  "year"
    t.integer "first",       :default => 0
    t.integer "last",        :default => 0
    t.integer "middle",      :default => 0
    t.integer "total",       :default => 0
  end

  add_index "author_journals", ["bibliome_id", "author_id", "year", "journal_id"], :name => "index_author_journals_on_bibliome_id_author_id_year_journal_id"
  add_index "author_journals", ["bibliome_id", "author_id", "year", "total"], :name => "index_author_journals_on_bibliome_id_author_id_year_total"
  add_index "author_journals", ["bibliome_id", "journal_id", "year", "total"], :name => "index_author_journals_on_bibliome_id_journal_id_year_total"

  create_table "author_pubtypes", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "author_id"
    t.integer "pubtype_id"
    t.string  "year"
    t.integer "first",       :default => 0
    t.integer "last",        :default => 0
    t.integer "middle",      :default => 0
    t.integer "total",       :default => 0
  end

  add_index "author_pubtypes", ["bibliome_id", "author_id", "year", "pubtype_id"], :name => "index_author_pubtypes_on_bibliome_id_author_id_year_pubtype_id"
  add_index "author_pubtypes", ["bibliome_id", "author_id", "year", "total"], :name => "index_author_pubtypes_on_bibliome_id_author_id_year_total"
  add_index "author_pubtypes", ["bibliome_id", "pubtype_id", "year", "total"], :name => "index_author_pubtypes_on_bibliome_id_pubtype_id_year_total"

  create_table "author_subjects", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "author_id"
    t.integer "subject_id"
    t.string  "year"
    t.integer "first_direct",      :default => 0
    t.integer "first_descendant",  :default => 0
    t.integer "first_total",       :default => 0
    t.integer "last_direct",       :default => 0
    t.integer "last_descendant",   :default => 0
    t.integer "last_total",        :default => 0
    t.integer "middle_direct",     :default => 0
    t.integer "middle_descendant", :default => 0
    t.integer "middle_total",      :default => 0
    t.integer "total_direct",      :default => 0
    t.integer "total_descendant",  :default => 0
    t.integer "total_total",       :default => 0
  end

  add_index "author_subjects", ["bibliome_id", "author_id", "year", "subject_id"], :name => "index_author_subjects_on_bibliome_id_author_id_year_subject_id"
  add_index "author_subjects", ["bibliome_id", "author_id", "year", "total_direct"], :name => "index_author_subjects_on_bibliome_author_year_total_direct"
  add_index "author_subjects", ["bibliome_id", "subject_id", "year", "total_direct"], :name => "index_author_subjects_on_bibliome_subject_year_total_direct"

  create_table "authors", :force => true do |t|
    t.string "last_name"
    t.string "fore_name"
    t.string "initials"
    t.string "suffix"
  end

  add_index "authors", ["last_name", "fore_name", "initials", "suffix"], :name => "index_authors_on_last_name_fore_name_initials_suffix", :unique => true
  add_index "authors", ["last_name", "initials"], :name => "index_authors_on_last_name_and_initials"

  create_table "authorships", :force => true do |t|
    t.integer "article_id"
    t.integer "author_id"
    t.integer "position"
    t.integer "last_position"
  end

  add_index "authorships", ["article_id", "position"], :name => "index_authorships_on_article_id_and_position"
  add_index "authorships", ["author_id"], :name => "index_authorships_on_author_id"

  create_table "bibliome_articles", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "article_id"
    t.date    "pubdate"
  end

  add_index "bibliome_articles", ["bibliome_id", "pubdate", "article_id"], :name => "index_bibliome_articles_on_bibliome_id_pubdate_article_id"

  create_table "bibliome_authors", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "author_id"
    t.string  "year"
    t.integer "articles_count", :default => 0
  end

  add_index "bibliome_authors", ["bibliome_id", "author_id", "year"], :name => "index_bibliome_authors_on_bibliome_id_and_author_id_and_year"
  add_index "bibliome_authors", ["bibliome_id", "year", "articles_count"], :name => "index_bibliome_authors_on_bibliome_id_year_articles_count"

  create_table "bibliome_genes", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "gene_id"
    t.string  "year"
    t.integer "articles_count", :default => 0
  end

  add_index "bibliome_genes", ["bibliome_id", "gene_id", "year"], :name => "index_bibliome_genes_on_bibliome_id_and_gene_id_and_year"
  add_index "bibliome_genes", ["bibliome_id", "year", "articles_count"], :name => "index_bibliome_genes_on_bibliome_id_and_year_and_articles_count"

  create_table "bibliome_journals", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "journal_id"
    t.string  "year"
    t.integer "articles_count", :default => 0
  end

  add_index "bibliome_journals", ["bibliome_id", "journal_id", "year"], :name => "index_bibliome_journals_on_bibliome_id_and_journal_id_and_year"
  add_index "bibliome_journals", ["bibliome_id", "year", "articles_count"], :name => "index_bibliome_journals_on_bibliome_id_year_articles_count"

  create_table "bibliome_pubtypes", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "pubtype_id"
    t.string  "year"
    t.integer "articles_count", :default => 0
  end

  add_index "bibliome_pubtypes", ["bibliome_id", "pubtype_id", "year"], :name => "index_bibliome_pubtypes_on_bibliome_id_and_pubtype_id_and_year"
  add_index "bibliome_pubtypes", ["bibliome_id", "year", "articles_count"], :name => "index_bibliome_pubtypes_on_bibliome_id_year_articles_count"

  create_table "bibliome_subjects", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "subject_id"
    t.string  "year"
    t.integer "articles_count", :default => 0
  end

  add_index "bibliome_subjects", ["bibliome_id", "subject_id", "year"], :name => "index_bibliome_subjects_on_bibliome_id_and_subject_id_and_year"
  add_index "bibliome_subjects", ["bibliome_id", "year", "articles_count"], :name => "index_bibliome_subjects_on_bibliome_id_year_articles_count"

  create_table "bibliomes", :force => true do |t|
    t.string   "name"
    t.text     "query"
    t.integer  "all_articles_count",  :default => 0
    t.integer  "all_journals_count",  :default => 0
    t.integer  "all_authors_count",   :default => 0
    t.integer  "all_subjects_count",  :default => 0
    t.integer  "all_genes_count",     :default => 0
    t.integer  "all_pubtypes_count",  :default => 0
    t.integer  "one_articles_count",  :default => 0
    t.integer  "one_journals_count",  :default => 0
    t.integer  "one_authors_count",   :default => 0
    t.integer  "one_subjects_count",  :default => 0
    t.integer  "one_genes_count",     :default => 0
    t.integer  "one_pubtypes_count",  :default => 0
    t.integer  "five_articles_count", :default => 0
    t.integer  "five_journals_count", :default => 0
    t.integer  "five_authors_count",  :default => 0
    t.integer  "five_subjects_count", :default => 0
    t.integer  "five_genes_count",    :default => 0
    t.integer  "five_pubtypes_count", :default => 0
    t.integer  "ten_articles_count",  :default => 0
    t.integer  "ten_journals_count",  :default => 0
    t.integer  "ten_authors_count",   :default => 0
    t.integer  "ten_subjects_count",  :default => 0
    t.integer  "ten_genes_count",     :default => 0
    t.integer  "ten_pubtypes_count",  :default => 0
    t.integer  "total_articles",      :default => 0
    t.integer  "hits",                :default => 0
    t.boolean  "built",               :default => false
    t.datetime "started_at"
    t.datetime "built_at"
    t.datetime "delete_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bibliomes", ["built", "built_at"], :name => "index_bibliomes_on_built_and_built_at"
  add_index "bibliomes", ["hits"], :name => "index_bibliomes_on_hits"
  add_index "bibliomes", ["name"], :name => "index_bibliomes_on_name", :unique => true

  create_table "coauthorships", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "author_id"
    t.integer "coauthor_id"
    t.string  "year"
    t.integer "first",       :default => 0
    t.integer "last",        :default => 0
    t.integer "middle",      :default => 0
    t.integer "total",       :default => 0
  end

  add_index "coauthorships", ["bibliome_id", "author_id", "year", "coauthor_id"], :name => "index_coauthorships_on_bibliome_id_author_id_year_coauthor_id"
  add_index "coauthorships", ["bibliome_id", "author_id", "year", "total"], :name => "index_coauthorships_on_bibliome_id_author_id_year_total"

  create_table "cosubjectships", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "subject_id"
    t.integer "cosubject_id"
    t.string  "year"
    t.integer "direct",       :default => 0
    t.integer "descendant",   :default => 0
    t.integer "total",        :default => 0
  end

  add_index "cosubjectships", ["bibliome_id", "subject_id", "year", "cosubject_id"], :name => "index_cosubjectships_on_bibliome_subject_year_cosubject"
  add_index "cosubjectships", ["bibliome_id", "subject_id", "year", "direct"], :name => "index_cosubjectships_on_bibliome_subject_year_direct"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genes", :force => true do |t|
    t.integer "taxonomy_id"
    t.string  "symbol"
  end

  add_index "genes", ["symbol"], :name => "index_genes_on_symbol"

  create_table "journal_pubtypes", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "journal_id"
    t.integer "pubtype_id"
    t.string  "year"
    t.integer "total",       :default => 0
  end

  add_index "journal_pubtypes", ["bibliome_id", "journal_id", "year", "pubtype_id"], :name => "index_journal_pubtypes_on_bibliome_journal_year_pubtype"
  add_index "journal_pubtypes", ["bibliome_id", "journal_id", "year", "total"], :name => "index_journal_pubtypes_on_bibliome_id_journal_id_year_total"
  add_index "journal_pubtypes", ["bibliome_id", "pubtype_id", "year", "total"], :name => "index_journal_pubtypes_on_bibliome_id_pubtype_id_year_total"

  create_table "journal_subjects", :force => true do |t|
    t.integer "bibliome_id"
    t.integer "journal_id"
    t.integer "subject_id"
    t.string  "year"
    t.integer "direct",      :default => 0
    t.integer "descendant",  :default => 0
    t.integer "total",       :default => 0
  end

  add_index "journal_subjects", ["bibliome_id", "journal_id", "year", "direct"], :name => "index_journal_subjects_on_bibliome_id_journal_id_year_direct"
  add_index "journal_subjects", ["bibliome_id", "journal_id", "year", "subject_id"], :name => "index_journal_subjects_on_bibliome_journal_year_subject"
  add_index "journal_subjects", ["bibliome_id", "subject_id", "year", "direct"], :name => "index_journal_subjects_on_bibliome_id_subject_id_year_direct"

  create_table "journals", :force => true do |t|
    t.string "title"
    t.string "abbr"
  end

  add_index "journals", ["abbr", "title"], :name => "index_journals_on_abbr_and_title"

  create_table "mesh_ancestors", :force => true do |t|
    t.integer "subject_id"
    t.integer "ancestor_id"
  end

  add_index "mesh_ancestors", ["subject_id"], :name => "index_mesh_ancestors_on_subject_id"

  create_table "mesh_trees", :force => true do |t|
    t.string  "tree_number"
    t.integer "subject_id"
    t.integer "parent_id"
  end

  add_index "mesh_trees", ["parent_id"], :name => "index_mesh_trees_on_parent_id"
  add_index "mesh_trees", ["subject_id"], :name => "index_mesh_trees_on_subject_id"
  add_index "mesh_trees", ["tree_number"], :name => "index_mesh_trees_on_tree_number", :unique => true

  create_table "published_genes", :force => true do |t|
    t.integer "article_id"
    t.integer "gene_id"
  end

  add_index "published_genes", ["article_id"], :name => "index_published_genes_on_article_id"

  create_table "pubtypes", :force => true do |t|
    t.string "term"
  end

  add_index "pubtypes", ["term"], :name => "index_pubtypes_on_term"

  create_table "subjects", :force => true do |t|
    t.string "term"
  end

  add_index "subjects", ["term"], :name => "index_subjects_on_term", :unique => true

  create_table "taxonomies", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.integer "article_id"
    t.integer "subject_id"
  end

  add_index "topics", ["article_id"], :name => "index_topics_on_article_id"

end
