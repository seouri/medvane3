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

ActiveRecord::Schema.define(:version => 20091217011057) do

  create_table "article_types", :force => true do |t|
    t.integer "article_id"
    t.integer "pubtype_id"
  end

  add_index "article_types", ["article_id"], :name => "index_article_types_on_article_id"
  add_index "article_types", ["pubtype_id"], :name => "index_article_types_on_pubtype_id"

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

  create_table "articles_bibliomes", :force => true do |t|
    t.integer "article_id"
    t.integer "bibliome_id"
  end

  add_index "articles_bibliomes", ["bibliome_id", "article_id"], :name => "index_articles_bibliomes_on_bibliome_id_and_article_id", :unique => true

  create_table "authors", :force => true do |t|
    t.string "last_name"
    t.string "fore_name"
    t.string "initials"
    t.string "suffix"
  end

  add_index "authors", ["last_name", "fore_name", "suffix"], :name => "index_authors_on_last_name_and_fore_name_and_suffix", :unique => true
  add_index "authors", ["last_name", "initials"], :name => "index_authors_on_last_name_and_initials"

  create_table "authorships", :force => true do |t|
    t.integer "article_id"
    t.integer "author_id"
    t.integer "position"
    t.integer "last_position"
  end

  add_index "authorships", ["article_id", "position"], :name => "index_authorships_on_article_id_and_position"
  add_index "authorships", ["author_id"], :name => "index_authorships_on_author_id"

  create_table "bibliomes", :force => true do |t|
    t.string   "name"
    t.text     "query"
    t.integer  "articles_count", :default => 0
    t.boolean  "built",          :default => false
    t.datetime "built_at"
    t.datetime "delete_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bibliomes", ["name"], :name => "index_bibliomes_on_name", :unique => true

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

  create_table "journals", :force => true do |t|
    t.string "title"
    t.string "abbr"
  end

  add_index "journals", ["abbr"], :name => "index_journals_on_abbr"
  add_index "journals", ["title"], :name => "index_journals_on_title"

  create_table "mesh_trees", :force => true do |t|
    t.string  "tree_number"
    t.integer "subject_id"
    t.integer "parent_id"
  end

  add_index "mesh_trees", ["parent_id"], :name => "index_mesh_trees_on_parent_id"
  add_index "mesh_trees", ["subject_id"], :name => "index_mesh_trees_on_subject_id"
  add_index "mesh_trees", ["tree_number"], :name => "index_mesh_trees_on_tree_number", :unique => true

  create_table "pubtypes", :force => true do |t|
    t.string "term"
  end

  add_index "pubtypes", ["term"], :name => "index_pubtypes_on_term"

  create_table "subjects", :force => true do |t|
    t.string "term"
  end

  add_index "subjects", ["term"], :name => "index_subjects_on_term", :unique => true

  create_table "topics", :force => true do |t|
    t.integer "article_id"
    t.integer "subject_id"
  end

end
