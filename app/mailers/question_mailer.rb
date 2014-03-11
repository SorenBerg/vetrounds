class QuestionMailer < ActionMailer::Base
  default from: "no-reply@vetrounds.com"

  def question_answered(question, answer)
    @question = question
    @answer = answer

    mail(
      to: @question.user.email,
      subject: 'Your Question has been Answered!'
    )
  end

  def answer_shared(current_user, answer, to_name, to_email)
    @current_user = current_user
    @answer = answer
    @to_name = to_name

    mail(
      to: to_email,
      subject: 'Vetrounds: ' + current_user.name + ' shared an answer with you'
    )
  end
end
