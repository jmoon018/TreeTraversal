helpers do
  def logged_in?
    !current_user.nil?
  end

  def current_user
    return nil unless current_user_id
    @current_user ||= User.find(current_user_id)
  end

  def current_user_id
    session[:current_user_id]
  end

  def logout
    session.delete :current_user_id
    @current_user = nil
  end

  def set_current_user user
    session[:current_user_id] = user.id
    @current_user = user
  end

  def authenticate name, password
    candidate = User.find_by(:name => name)
    if !candidate.blank?

      if candidate.password_hash.blank?
        # Use Unsafe Old Password
        set_current_user(candidate) if candidate.read_attribute(:password) == password
      else
        # Use BCrypt Override
        set_current_user candidate if candidate.password == password
      end
    else
      false
    end
  end
end
