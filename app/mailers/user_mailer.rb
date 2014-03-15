class UserMailer < ActionMailer::Base
  default from: "no-reply@vetrounds.com"

  def welcome_email(user)
    @user = user

    if (@user.is_vet)
      template_name = 'welcome_doctor_email'
    else
      template_name = 'welcome_client_email'
    end

    headers['X-SMTPAPI'] = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"Unsubscribe <%Here%>","text/plain":"Unsubscribe Here: <% %>"}}}}'

    mail(
      to: @user.email,
      subject: 'Welcome to Vetrounds',
      template_name: template_name
    )
  end

  def password_reset(user)
    @user = user

    headers['X-SMTPAPI'] = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"Unsubscribe <%Here%>","text/plain":"Unsubscribe Here: <% %>"}}}}'

    mail(
      to: user.email,
      subject: "Vetrounds : Password Reset"
    )
  end
end
