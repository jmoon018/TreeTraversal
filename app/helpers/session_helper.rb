helpers do
  def session_logged_in?
    !session_current_user.nil?
  end

  def session_current_user
    return nil if session_current_user_id.blank?
    if User.where(id: session_current_user_id).any?
      @current_user ||= User.find(session_current_user_id)
    else
      session_logout
    end
  end

  def session_current_user_id
    session[:current_user_id]
  end

  def session_logout
    session.delete :current_user_id
    @session_current_user = nil
  end

  def session_set_current_user user
    session[:current_user_id] = user.id
    @current_user = user
  end

  def session_authenticate name, password
    candidate = User.find_by(:name => name)
    if !candidate.blank?

      if candidate.password_hash.blank?
        # Use Unsafe Old Password
        session_set_current_user(candidate) if candidate.read_attribute(:password) == password
      else
        # Use BCrypt Override
        session_set_current_user candidate if candidate.password == password
      end
    else
      false
    end
  end
end
