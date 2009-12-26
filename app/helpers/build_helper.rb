module BuildHelper
  def processing_time(bibliome)
    to_time = bibliome.built_at || Time.now
    from_time = bibliome.started_at || Time.now
    distance_of_time_in_words(from_time, to_time, true)
  end
end
