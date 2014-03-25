class UsersController < ApplicationController
  def new
    if signed_in?
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
    if !signed_in?
      redirect_to root_url
      return
    end

    @user = User.find_by_id(params[:id])

    if (@user.nil?)
      redirect_to root_url
      return
    end
  end

  def update_image
    if !signed_in?
      redirect_to root_url
      return
    end

    @user = User.find_by_id(params[:user][:user_id])

    if (@user.nil? or @user != current_user)
      redirect_to root_url
      return
    end

    @user.update_attributes(client_params)
    redirect_to user_show_path(:id => @user.id)
  end



  private
    def client_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, detail_attributes: [:zipcode])
    end

    def vet_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, detail_attributes: [:zipcode, :area_of_practice, :vetinary_school, :vetinary_school_year, :degree, :licence_number, :licence_state])
    end
end
