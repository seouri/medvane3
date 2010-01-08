# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title(title)
    content_for(:title) {title}
  end

  def has_chart
    content_for(:has_chart) {true}
  end
  
  def sparkline(dat)
    dat = [[1999, 5], [2001, 10], [2002, 3], [2006, 12]]
  end
  
  def count(val, type="article")
    content_tag(:span, "(" + pluralize(number_with_delimiter(val), type) + ")", :class => "count")
  end

  def top_neighbors(neigbors, klass)
    unless neigbors.blank?
      div = []
      div.push(content_tag(:h3, "Top #{klass.pluralize.titleize}"))
      count_col = ["direct", "total_direct", "total"].select {|c| neigbors.first.respond_to?(c) }.first
      li = neigbors.map {|item| content_tag(:li, link_to_item(item, klass) + " " + count(item.send(count_col)))}
      ol = content_tag(:ol, li.join("\n"))
      div.push(ol)
      content_tag(:div, div.join("\n"), :class => "top_neighbors", :id => "top_#{klass}")
    end
  end

  def link_to_item(item, klass)
    path_class = klass.gsub(/^co/, "")
    link_to(item.send(klass).to_l, send("bibliome_#{path_class}_path", item.bibliome, item.send(klass)))
  end
end
