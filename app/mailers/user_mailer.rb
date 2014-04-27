class UserMailer < ActionMailer::Base
  default from: "no-reply@vetrounds.com"

  def sendgrid_unsub_header
    '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"Unsubscribe <%Here%>","text/plain":"Unsubscribe Here: <% %>"}}}}'
  end

  def welcome_email(user)
    @user = user

    if (@user.is_vet)
      template_name = 'welcome_doctor_email'
    else
      template_name = 'welcome_client_email'
    end

    headers['X-SMTPAPI'] = sendgrid_unsub_header

    mail(
      to: @user.email,
      subject: 'Welcome to VetRounds',
      template_name: template_name
    )
  end

  def password_reset(user)
    @user = user

    headers['X-SMTPAPI'] = sendgrid_unsub_header

    mail(
      to: user.email,
      subject: "Vetrounds : Password Reset"
    )
  end
  
  def vet_enable_email(user)
    @user = user

    headers['X-SMTPAPI'] = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"Unsubscribe <%Here%>","text/plain":"Unsubscribe Here: <% %>"}}}}'

    mail(
      to: user.email,
      subject: 'Your account on VetRounds has been enabled',
    )
  end

  def appointment_request_email(from, to, request, answer)
    @from = from
    @to = to
    @request = request
    @answer = answer

    headers['X-SMTPAPI'] = sendgrid_unsub_header

    mail(
      to: to.email,
      subject: "#{from.name} requests an appointment",
    )
  end
  
  def internal_vet_notify(user)
    @user = user

    headers['X-SMTPAPI'] = '{"filters":{"subscriptiontrack":{"settings":{"enable":1,"text/html":"Unsubscribe <%Here%>","text/plain":"Unsubscribe Here: <% %>"}}}}'

    mail(
      to: 'joe@vetrounds, soren@vetrounds.com, brian@vetrounds.com',
      subject: 'A new vet account has been created',
    )
  end
end
