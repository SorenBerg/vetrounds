module ThanksHelper
  def has_thanked (answer_id)
    if !signed_in?
      return false
    end

    if current_user.is_vet
      return false
    end

    @answer = Answer.find_by_id(answer_id)

    if @answer.nil?
      return false
    end

    return Thank.exists?(:question_id => @answer.question_id, :answer_id => @answer.id, :from_id => current_user.id)
  end

  def get_thanks_count(user_id)
    if !signed_in?
      return 0
    end

    @user = User.find_by_id(user_id)

    if @user.nil?
      return 0
    end

    if !@user.is_vet
      return 0
    end

    return Thank.where(:to_id => user_id).count
  end
end
