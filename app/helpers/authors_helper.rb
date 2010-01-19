module AuthorsHelper
  def see_also(author)
    return if author.see_also.size == 0
    period = @period == "all" ? nil : @period
    li = []
    author.see_also.each do |see|
      li.push(content_tag(:li, link_to(see.to_l, bibliome_author_path(@bibliome, see, :period => period) + "/#{period}")))
    end
    ul = content_tag :ul, li.join("\n")
    content_tag :div,"See also: " + ul, :id => "see_also"
  end
end
