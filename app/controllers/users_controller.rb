class UsersController < ApplicationController
  def new
    if signed_in?
      flash[:notice] = "You are already logged in.  Click 'My Profile' to see your profile."
      redirect_to root_url
      return
    end

    @user = User.new
    @user.build_detail
  end

  def create_client
    if signed_in?
      redirect_to root_url
      return
    end

    @user = User.new(client_params)

    if (@user.save)
      UserMailer.welcome_email(@user).deliver
      sign_in @user

      #Mixpanel
      register_properties(created_at: @user.created_at, email: @user.email, user_type: "client")
      track_event("Client Sign Up", signup_type: "seperate")
      mixpanel_alias(@user.id.to_s)

      redirect_to user_show_path(:id => @user.id)
    else
      render 'new'
    end
  end

  def create_vet
    if signed_in?
      redirect_to root_url
      return
    end

    @user = User.new(vet_params)
    @user.is_vet = true
    @user.enabled = false

    if (@user.save)
      UserMailer.welcome_email(@user).deliver

      #Mixpanel
      register_properties(created_at: @user.created_at, email: @user.email, user_type: "vet")
      track_event("Vet Sign Up", signup_type: "seperate")
      mixpanel_alias(@user.id.to_s)

      flash[:notice] = "Your request to join the VetRounds network has been received and we will review your medical credentials. You will recieve an email when your account is approved."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show

    @user = User.find_by_id(params[:id])

    if (@user.nil?)
      redirect_to root_url
      return
    end
  end

  def update_user
    if !signed_in?
      redirect_to root_url
      return
    end

    @user = User.find_by_id(params[:user][:id])

    if (@user.nil? or @user != current_user)
      redirect_to root_url
      return
    end

    @user.update_attributes(vet_params)
    redirect_to user_show_path(:id => @user.id)
  end

  def request_appointment
    if !signed_in?
      flash[:notice] = "You must create an account to request an appointment"
      redirect_to signup_url
      return
    end
    user = User.find_by_id(params[:from_id])
    vet = User.find_by_id(params[:to_id])
    request = params[:request]
    answer = Answer.find_by_id(params[:answer_id])

    if (user.nil? or vet.nil? or user != current_user)
      redirect_to root_url
      return
    end

    UserMailer.appointment_request_email(user, vet, request, answer).deliver
    flash[:notice] = "Request sent, the vet may respond by email"
    
    redirect_to user_show_path(:id => user.id)
  end



  private
    def client_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms, detail_attributes: [:zipcode])
    end

    def vet_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :terms, :question_notification, detail_attributes: [:zipcode, :area_of_practice, :veterinary_school, :veterinary_school_year, :degree, :license_number, :license_state])
    end
end
