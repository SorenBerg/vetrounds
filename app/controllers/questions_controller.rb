class QuestionsController < ApplicationController
  def new
    #called on page load
    @question = Question.new

    if !signed_in?
      @user = User.new
      @user.build_detail
    end
  end

  def newpost
    #called on page load
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
        track_event("Create Question")

        notify_vet

        flash[:notice] = "Your question has been submitted to the VetRounds network of licensed veterinarians. You will recieve an email when your question is answered."
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
          notify_vet
          sign_in @user

          register_properties(created_at: @user.created_at, email: @user.email, user_type: "client")
          track_event("Client Sign Up", signup_type: "combined")
          track_event("Create Question")
          mixpanel_alias(@user.id.to_s)

          flash[:notice] = "Your question has been submitted to the VetRounds network of licensed veterinarians. You will recieve an email when your question is answered."
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
      @newanswer = Answer.new
    end
  end

  def search
    @search_results = Question.search(params[:search])
  end

  private
    def question_params
      params.require(:question).permit(:content, :animal_type, :animal_age, :gender, :medication, :medication_detail, :flea_preventives_detail, :current_medical_conditions, :current_medical_conditions_detail, :previous_medical_conditions, :previous_medical_conditions_detail, :feed_pet_detail)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms, detail_attributes: [:zipcode])
    end
  
    def notify_vet
      User.where(is_vet: true, enabled: true).where.not(question_notification: "none").find_each(batch_size: 500) do |vet|
        if vet.question_notification == "all" or (vet.question_notification == "nearby" and vet.detail.zipcode == @question.user.detail.zipcode)
          QuestionMailer.question_asked(@question, vet).deliver
        end
      end
    end
end
