class AnswersController < ApplicationController
  def create
    if !signed_in?
      redirect_to root_url
    end

    if !current_user.is_vet
      redirect_to root_url
    end

    @answer = Answer.new(answer_param)
    @answer.user_id = current_user.id

    if (@answer.save)
      track_event("Answer Question")
      @question = Question.find(@answer.question_id)

      @question.answered = true

      QuestionMailer.question_answered(@question, @answer).deliver

      @question.save
    end

    redirect_to question_show_path(:id => @answer.question_id)
  end

  def share_answer
    if !signed_in?
      redirect_to root_url
      return
    end

    @answer = Answer.find_by_id(params[:id])

    if (@answer.nil?)
      redirect_to root_url
      return
    end

    if params[:to_name].blank? || params[:to_email].blank?
      redirect_to question_show_path(:id => @answer.question.id)
      return
    end

    if !valid_email?(params[:to_email])
      redirect_to question_show_path(:id => @answer.question.id)
      return
    end

    QuestionMailer.answer_shared(
      current_user,
      @answer,
      params[:to_name],
      params[:to_email]
    ).deliver

    track_event("Share")

    redirect_to question_show_path(:id => @answer.question.id)
  end

  private
    def answer_param
      params.require(:answer).permit(:answer, :question_id)
    end

    def valid_email?(email)
      email.present? && (email =~ /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i)
    end
end
