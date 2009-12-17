module Bio
  class MEDLINE < NCBIDB
    def initialize(entry)
      # PMID: 19900898. One MH could span in more than one lines.
      # In such cases, the second line is recognized as another MH rather than 
      # part of the first line. 
      # To fix this bug, each line should be checked whether it starts with a
      # tag (new item) or not (wrapped line of the preceding tag).
      # If it is a wrapped line of the preceding tag, the last character ("\n")
      # is replaced with a space before the current line is appended.
      @pubmed = Hash.new('')

      tag = ''
      entry.each_line do |line|
        with_tag = false # bug fix
        if line =~ /^\w/
          tag = line[0,4].strip
          with_tag = true # bug fix
        end
        @pubmed[tag][-1] = " " unless with_tag # bug fix
        @pubmed[tag] += line[6..-1] if line.length > 6
      end
    end
    attr_reader :pubmed
    
    def jt
      @pubmed['JT'].gsub(/\s+/, ' ').strip
    end
    
    def authors
      authors = []
      @pubmed['AU'].strip.split(/\n/).each do |author|
        name = author.split(/\s+/)
        suffix = nil
        if name.length > 2 && name[-2] =~ /^[A-Z]+$/
          suffix = name.pop
        end
        initials = name.pop
        author = {
          "last_name" => name[0], 
          "fore_name" => initials, 
          "initials" => initials, 
          "suffix" => suffix,
        }
        authors.push(author)
      end
      return authors
    end
    
    def major_descriptors
      #@pubmed['MH'].strip.split(/\n/).select {|m| m.match(/\*/)}.map {|m| m.gsub(/\/.+$/, "")}
      mh.select {|m| m.match(/\*/)}.map {|m| m.gsub(/\*|\/.+$/, "")}
    end
  end
end