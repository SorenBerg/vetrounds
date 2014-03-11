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

  private
    def client_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, detail_attributes: [:zipcode])
    end

    def vet_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, detail_attributes: [:zipcode, :area_of_practise, :vetinary_school, :vetinary_school_year, :degree, :licence_number, :licence_state])
    end
end
