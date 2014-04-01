module ThanksHelper
  def has_thanked (answer)
    get_thank_from_current_user(answer) != nil
  end

  def get_thank_from_current_user (answer)
    if answer.nil?
      return nil
    end

    current_user.thanks.where(answer: answer).first
  end
end
