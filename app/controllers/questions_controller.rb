class QuestionsController < ApplicationController
  def new
    @question = Question.new

    if !signed_in?
      @user = User.new
      @user.build_detail
    end
  end

  def newpost
    @question = Question.new
    @question.content = params[:question]

    if !signed_in?
      @user = User.new
      @user.build_detail
    end
  end

  def create
    if signed_in?
      @question = Question.new(question_params)
      @question.user_id = current_user.id

      if (@question.save)
        redirect_to question_show_path(:id => @question.id)
      else
        render 'new'
      end
    else
      @user = User.new(user_params)
      @question = Question.new(question_params)

      if (@user.save)
        @question.user_id = @user.id

        if (@question.save)
          UserMailer.welcome_email(@user).deliver
          sign_in @user
          redirect_to user_show_path(:id => @user.id)
          return
        else
          @user.delete
        end
      end

      render 'new'
    end
  end

  def list
    if !signed_in?
      redirect_to root_url
    end

    @open_questions = Question.where("answered = 'f'")
    @close_questions = Question.where("answered = 't'")
  end

  def show
    if !signed_in?
      redirect_to root_url
      return
    end

    @question = Question.find(params[:id])

    if current_user.is_vet
      @answer = Answer.new
    end
  end

  def search
    @search_results = Question.search(params[:search])
  end

  private
    def question_params
      params.require(:question).permit(:content, :animal_type, :animal_age, :medication, :medication_detail, :flea_preventives_detail, :current_medical_conditions, :current_medical_conditions_detail, :previous_medical_conditions, :previous_medical_conditions_detail, :feed_pet_detail)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, detail_attributes: [:zipcode])
    end
end
