module AgreementsHelper
  def has_agreed (answer_id)
    if !signed_in?
      return false
    end

    if !current_user.is_vet
      return false
    end

    @answer = Answer.find_by_id(answer_id)

    if @answer.nil?
      return false
    end

    if @answer.user == current_user
      return false
    end

    return Agreement.exists?(:question_id => @answer.question_id, :answer_id => @answer.id, :from_id => current_user.id)
  end

  def get_agreement_count(user_id)
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

    return Agreement.where(:to_id => user_id).count
  end
end
