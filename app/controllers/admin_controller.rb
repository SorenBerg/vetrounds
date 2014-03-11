class AdminController < ApplicationController
  def login
    if signed_in?
      redirect_to admin_path
      return
    end
  end

  def loginpost
    if signed_in?
      redirect_to admin_path
      return
    end

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) && user.is_admin
      sign_in user
      redirect_to admin_path
      return
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'login'
    end
  end

  def listvet
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @vets = User.where("is_vet = 't' AND is_admin != 't'")
  end

  def listclient
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @clients = User.where("is_vet IS NULL")
  end

  def createclient
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @user = User.new
    @user.build_detail
  end

  def createclientpost
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @user = User.new(client_params)

    if (@user.save)
      UserMailer.welcome_email(@user).deliver
      redirect_to admin_view_client_path(:id => @user.id)
    else
      render 'createclient'
    end
  end

  def createvet
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @user = User.new
    @user.build_detail
  end

  def createvetpost
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @user = User.new(vet_params)
    @user.is_vet = true
    @user.enabled = false

    if (@user.save)
      redirect_to admin_view_vet_path(:id => @user.id)
    else
      render 'createvet'
    end
  end

  def viewclient
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @client = User.find_by_id(params[:id])

    if @client.nil?
      redirect_to admin_path
      return
    end

    if @client.is_vet
      redirect_to admin_path
      return
    end
  end

  def viewvet
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @vet = User.find_by_id(params[:id])

    if @vet.nil?
      redirect_to admin_path
      return
    end

    if !@vet.is_vet
      redirect_to admin_path
      return
    end
  end

  def enablevet
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @user = User.find_by_id(params[:id])

    if @user.nil?
      redirect_to admin_path
      return
    end

    @user.enabled = true
    @user.save

    redirect_to admin_path
    return
  end

  def disablevet
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @user = User.find_by_id(params[:id])

    if @user.nil?
      redirect_to admin_path
      return
    end

    @user.enabled = false
    @user.save

    redirect_to admin_path
    return
  end

  def enableclient
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @user = User.find_by_id(params[:id])

    if @user.nil?
      redirect_to admin_path
      return
    end

    @user.enabled = true
    @user.save

    redirect_to admin_clients_path
    return
  end

  def disableclient
    if signed_in?
      if !current_user.is_admin
        redirect_to root_url
        return
      end
    end

    if !signed_in?
      redirect_to admin_login_path
      return
    end

    @user = User.find_by_id(params[:id])

    if @user.nil?
      redirect_to admin_path
      return
    end

    @user.enabled = false
    @user.save

    redirect_to admin_clients_path
    return
  end
end
