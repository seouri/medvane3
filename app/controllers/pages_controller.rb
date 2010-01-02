class PagesController < ApplicationController
  def home
    @recent = Bibliome.recent(5)
    @popular = Bibliome.popular(5)
  end

  def about
  end

  def help
  end

end
