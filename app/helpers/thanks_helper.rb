module ThanksHelper
  def has_thanked (answer)
    if answer.nil?
      return false
    end

    int = answer.thanks & current_user.thanks
    return int.length > 0
  end
end
