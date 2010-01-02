module BibliomesHelper
  def status(bibliome)
    unless bibliome.built?
      percentage = sprintf("%.1f", bibliome.articles_count.to_f / bibliome.total_articles.to_f * 100)
      started_at = bibliome.started_at || Time.now
      rate = bibliome.articles_count.to_f / (Time.now - started_at)
      time_left = ((bibliome.total_articles - bibliome.articles_count).to_f / rate).to_i if bibliome.articles_count > 0
      estimate = bibliome.articles_count == 0 ? "undetermined yet" : distance_of_time_in_words(Time.now, Time.now + time_left)
      status = "#{bibliome.articles_count} of #{bibliome.total_articles} articles (#{percentage}%) imported in #{processing_time(bibliome)}. Estimated time to finish importing is #{estimate}."
      content_tag(:div, status, :id => "bibliome_status")
    end
  end
  
  def processing_time(bibliome)
    to_time = bibliome.built_at || Time.now
    from_time = bibliome.started_at || Time.now
    distance_of_time_in_words(from_time, to_time, true)
  end
end
