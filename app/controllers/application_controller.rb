class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include AgreementsHelper
  include ThanksHelper
  around_filter :append_event_tracking_tags

  def mixpanel_distinct_id
    current_user && current_user.id.to_s
  end

  def mixpanel_name_tag
    current_user && current_user.email
  end
end