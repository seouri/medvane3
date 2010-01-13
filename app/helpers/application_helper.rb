# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title(*args)
    @page_title = args.join(" | ")
    content_for(:title) {@page_title}
  end

  def page_header(bibliome)
    header_text = @page_title
    if bibliome
      period = @period == "all" ? nil : @period
      header_text = link_to_unless_current(h(@bibliome.query), bibliome_path(@bibliome, :period => period)) + " | " + bibliome_nav(bibliome)
    end
    content_tag(:h1, header_text)
  end

  def bibliome_nav(bibliome)
    period = @period == "all" ? nil : @period
    li = []
    ["articles", "journals", "authors", "subjects", "pubtypes"].each do |obj|
      css_class = controller.controller_name == obj ? "current" : nil
      item = content_tag(:li, link_to(obj, send("bibliome_#{obj}_path", bibliome, :period => period)), :class => css_class)
      li.push(item)
    end
    content_tag(:ul, li.join("\n"), :id => "bibliome_nav")
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
    period = @period == "all" ? nil : @period
    link_to(item.send(klass).to_l, send("bibliome_#{path_class}_path", item.bibliome, item.send(klass), :period => period))
  end

  def period_tab(period="all")
    periods = [ ["all", "All Time"], ["one", "Last Year"], ["five", "Last 5 Years"], ["ten", "Last 10 Years"] ]
    li = []
    periods.each do |p|
      period_key = p[0]
      period_val = p[1]
      li_class = period == period_key ? "current" : nil
      link_text = period_val
      period_key = nil if period_key == "all"
      link = url_for(:period => period_key)
      li.push(content_tag(:li, link_to_unless(li_class, link_text, link), :class => li_class))
    end
    content_tag(:ul, li.join("\n"), :id => "period_tab")
  end

  def publication_history(bibliome, object)
    collection_name = "bibliome_" + object.class.to_s.pluralize.downcase
    data = object.send(collection_name).bibliome(bibliome)
    if data.size > 0
      years = data.select {|d| d.year.match(/^\d+$/) }.map {|d| d.year}.sort
      years_range = (years.first .. years.last).to_a
      x_axis_label = years_range.map {|y| y == years.first || y == years.last ? y : "" }
      data_by_year = data.group_by(&:year)
      articles = years_range.map {|y| data_by_year[y].nil? ? 0 : data_by_year[y][0].articles_count } 
      article_max = number_with_delimiter(articles.sort.last)
      content_tag(:div, bar_chart(articles, x_axis_label, article_max), :id => "publication_history")
    end
  end

  def bar_chart(data, x_axis_label, y_axis_max, legend = nil)
    x_axis_label[0] = "" unless x_axis_label.size == 1 || x_axis_label.size > 5
    width = x_axis_label.size * 8 + y_axis_max.to_s.size * 6 + 10 + 10
    width += 70 unless legend.nil?
    colors = case data.size
      when 2: "000066,999999"
      when 3: "660000,999999,000066"
      else "999999"
    end
    Gchart.bar(:data => data, :axis_labels => [x_axis_label, [0, y_axis_max]], :bar_colors => colors, :legend => legend, :size => "#{width}x40", :axis_with_labels => 'x,y', :bar_width_and_spacing => {:width => 5, :spacing => 3}, :format => 'image_tag', :alt => "publication history")
  end  
end
