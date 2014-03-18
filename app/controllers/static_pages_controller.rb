class StaticPagesController < ApplicationController
  def home
  	track_event("Load Homepage")
  end
end
