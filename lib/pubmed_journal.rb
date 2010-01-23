require 'open-uri'
require 'libxml'

module PubmedJournal
  class JournalCallback
    include LibXML::XML::SaxParser::Callbacks

    CONTENT_KEY   = '__content__'.freeze
    HASH_SIZE_KEY = '__hash_size__'.freeze

    attr_reader :journals

    def current_hash
      @hash_stack.last
    end

    def on_start_document
      @hash = { CONTENT_KEY => '' }
      @hash_stack = [@hash]
      @journals = []
    end

    def on_end_document
      @hash = @hash_stack.pop
      @hash.delete(CONTENT_KEY)
    end

    def on_start_element(name, attrs)
      new_hash = { CONTENT_KEY => '' }.merge(attrs)
      new_hash[HASH_SIZE_KEY] = new_hash.size + 1

      case current_hash[name]
        when Array then current_hash[name] << new_hash
        when Hash  then current_hash[name] = [current_hash[name], new_hash]
        when nil   then current_hash[name] = new_hash
      end

      @hash_stack.push(new_hash)
    end

    def on_end_element(name)
      if name == 'Journal' && current_hash['MedAbbr'].nil? == false
        c = current_hash
        id = c['jrid']
        name = c['Name'][CONTENT_KEY]
        abbr = c['MedAbbr'][CONTENT_KEY]
        @journals.push([id, name, abbr])
      end
      if current_hash.length > current_hash.delete(HASH_SIZE_KEY) && (current_hash[CONTENT_KEY].nil? || current_hash[CONTENT_KEY].empty?) || current_hash[CONTENT_KEY] == ''
        current_hash.delete(CONTENT_KEY)
      end
      @hash_stack.pop
    end

    def on_characters(string)
      current_hash[CONTENT_KEY] << string
    end

    alias_method :on_cdata_block, :on_characters
  end
  
  def get
    url = "ftp://ftp.ncbi.nih.gov/pubmed/jourcache.xml"
    parser = LibXML::XML::SaxParser.io(open(url))
    updater = JournalCallback.new
    parser.callbacks = updater
    parser.parse
    updater.journals
  end
  module_function :get
end
