class ThanksController < ApplicationController
  def new
    return unless check_current_user

    @answer = Answer.find_by_id(params[:answer_id])

    if (@answer.nil?)
      redirect_to root_path
      return
    end

    if has_thanked(@answer)
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
    return unless check_current_user

    @answer = Answer.find_by_id(params[:answer_id])
    thank = get_thank_from_current_user(@answer)
    if thank
      thank.destroy
    end

    redirect_to question_show_path(:id => @answer.question_id)
    return
  end

  def update
    return unless check_current_user

    params.require(:thank).permit(:id, :feedback)

    thank = Thank.find_by_id(params[:thank][:id])
    thank.update_attributes(:feedback => params[:thank][:feedback])    

    redirect_to question_show_path(:id => thank.answer.question_id)
    return
  end

  private
    def check_current_user
      if !signed_in?
        redirect_to root_path
        return false
      end

      if current_user.is_vet
        redirect_to root_path
        return false
      end
      return true
    end
end
