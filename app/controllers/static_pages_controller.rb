class StaticPagesController < ApplicationController
  def home
    track_event("Load Homepage")
    answers = Answer.find(:all)
    @active_content = answers.select{|a| a.question.is_consult == false and a.agreements.count > 0 and a.user.id != 35 }.sample(3)
    if @active_content.length < 3
    	@active_content = @active_content * 3
    end

    vets = User.where("is_vet = 't' AND is_admin != 't'").order(:id)
    @top5 = vets.select { |vet| vet.id != 35 and vet.id != 72 }.take(5)
  	if @top5.length < 5
    	@top5 = @top5 * 5
    end
  end

  def terms
  end
end
