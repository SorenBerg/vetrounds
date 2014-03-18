class ThanksController < ApplicationController
  def new
    if !signed_in?
      redirect_to root_path
      return
    end

    if current_user.is_vet
      redirect_to root_path
      return
    end

    @answer = Answer.find_by_id(params[:answer_id])

    if (@answer.nil?)
      redirect_to root_path
      return
    end

    if has_thanked(@answer.id)
      redirect_to question_show_path(:id => @answer.question_id)
      return
    end

    @thank = Thank.new(question_id: @answer.question_id, answer_id: @answer.id, from_id: current_user.id, to_id: @answer.user.id)

    @thank.save

    track_event("Thank")

    redirect_to question_show_path(:id => @answer.question_id)
    return
  end

  def destroy
    if !signed_in?
      redirect_to root_path
      return
    end

    if current_user.is_vet
      redirect_to root_path
      return
    end

    @answer = Answer.find_by_id(params[:answer_id])

    if (@answer.nil?)
      redirect_to root_path
      return
    end

    if !has_thanked(@answer.id)
      redirect_to question_show_path(:id => @answer.question_id)
      return
    end

    Thank.destroy_all(:question_id => @answer.question_id, :answer_id => @answer.id, :from_id => current_user.id)

    redirect_to question_show_path(:id => @answer.question_id)
    return
  end
end
