class StaticPagesController < ApplicationController
  def home
  	track_event("Load Homepage")
  end

  def terms
  end
end
