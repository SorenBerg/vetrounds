class SessionsController < ApplicationController
  def new
    if signed_in?
      redirect_to root_url
    end
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) && !user.is_admin
      if user.enabled
        track_event("Log In")
        sign_in user
        redirect_to user_show_path(:id => user.id)
        return
      else
        flash.now[:notice] = 'Your doctor account is being reviewed. You will receive an email when it is approved.'
        render 'new'
      end
    else
      flash.now[:notice] = 'The username or password you entered is incorrect.'
      render 'new'  
    end
  end

  def destroy
    sign_out
    redirect_to root_url
    return
  end

  def reset
    if signed_in?
      redirect_to root_url
    end

    @user = User.find_by_password_reset_token(params[:id])

    if @user.nil?
      redirect_to root_path
      return
    end

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to password_forgot_path
      return
    end
  end

  def reset_post
    if signed_in?
      redirect_to root_url
    end

    @user = User.find_by_password_reset_token(params[:id])

    if @user.nil?
      redirect_to root_path
      return
    end

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to password_forgot_path
      return
    end

    if @user.update_attributes(reset_params)
      redirect_to root_url
      return
    else
      render 'reset'
    end
  end

  def forgot
    if signed_in?
      redirect_to root_url
    end
  end

  def forgot_post
    if signed_in?
      redirect_to root_url
    end

    user = User.find_by_email(params[:user][:email])

    if user.nil?
      redirect_to password_forgot_path
      return
    end

    user.send_password_reset
    redirect_to root_url
  end

  private
    def reset_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
