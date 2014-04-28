class StaticPagesController < ApplicationController
  def home
    track_event("Load Homepage")
    answers = Answer.find(:all)
    answers.find_all{|a| a.question.is_consult == false }.sort_by{|a| a.agreements.count}.take(5)
    @active_content =  answers
    
    vets = User.where("is_vet = 't' AND is_admin != 't'")
    @top5 = vets.reverse.sort_by { |vet| vet.answers.count }.take(5)

    # @top5 = [
    # 		User.find(2),
    # 		User.find(62),
    # 		User.find(76),
    # 		User.find(110),
    # 		User.find(109)
    # 	]
  end

  def terms
  end
end
