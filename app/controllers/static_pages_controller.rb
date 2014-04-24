class StaticPagesController < ApplicationController
  def home
    track_event("Load Homepage")
    @active_content = Answer.take(5)
  end

  def home2
  	@active_content = Answer.take(5)
  	@top5 = User.where("is_vet = 't' AND is_admin != 't'").take(5) * 5
  end

  def terms
  end
end
