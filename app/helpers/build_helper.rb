module BuildHelper
  def processing_time(bibliome)
    to_time = bibliome.built_at || Time.now
    distance_of_time_in_words(bibliome.created_at, to_time)
  end
end
