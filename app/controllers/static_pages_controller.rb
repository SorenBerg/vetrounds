class StaticPagesController < ApplicationController
  def home
    track_event("Load Homepage")
    @active_content = Answer.take(5)
  end

  def terms
  end
end
