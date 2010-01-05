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
end
