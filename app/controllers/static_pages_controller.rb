class StaticPagesController < ApplicationController
  def home
  	track_event("Load homepage")
  end
end
