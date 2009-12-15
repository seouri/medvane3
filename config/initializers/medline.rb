module Bio
  class MEDLINE < NCBIDB
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
  end
end