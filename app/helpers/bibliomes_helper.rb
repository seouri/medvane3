module BibliomesHelper
  def status(bibliome)
    unless bibliome.built?
      status = "#{bibliome.total_articles} articles are enqueued for importing. Please bookmark this page and come back later."
      progressbar = ''
      if bibliome.all_articles_count > 0
        percentage = sprintf("%d", bibliome.all_articles_count.to_f / bibliome.total_articles.to_f * 100)
        started_at = bibliome.started_at || Time.now
        rate = bibliome.all_articles_count.to_f / (Time.now - started_at)
        time_left = ((bibliome.total_articles - bibliome.all_articles_count).to_f / rate).to_i
        estimate = distance_of_time_in_words(Time.now, Time.now + time_left)
        status = "#{number_with_delimiter(bibliome.all_articles_count)} of #{number_with_delimiter(bibliome.total_articles)} articles (#{percentage}%) were imported in #{processing_time(bibliome)} (#{bibliome.build_speed}). Estimated time to finish importing is #{estimate}."
        progressbar = content_tag(:div, content_tag(:div, content_tag(:div, "#{percentage}%", :style => "padding-left: 0.5em"), :style => "background-color: #ccc; width: #{percentage}%; border-right: 1px solid #913"), :style => "border: 1px solid #913; margin-top: 0.5em")
      end
      content_tag(:div, status + progressbar, :id => "bibliome_status")
    end
  end
  
  def processing_time(bibliome)
    to_time = bibliome.built_at || Time.now
    from_time = bibliome.started_at || Time.now
    distance_of_time_in_words(from_time, to_time, true)
  end

  def age(bibliome)
    if bibliome.built?
      time_ago_in_words(bibliome.built_at) + " ago"
    else
      "in process"
    end
  end

  def summary(bibliome)
    if bibliome.built?
      li = []
      ["article", "journal", "author", "subject", "pubtype"].each do |obj|
        counter_field = "#{@period}_#{obj}s_count"
        count = bibliome.send(counter_field)
        link_text = pluralize(number_with_delimiter(count), obj.titleize)
        link_path = controller.send("bibliome_#{obj}s_path", bibliome, :period => @link_period)
        li.push(content_tag(:li, link_to(link_text, link_path)))
      end
      content_tag(:ul, li.join("\n"))
    end
  end
end
