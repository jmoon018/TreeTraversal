get '/' do
  @user_id = session[:current_user_id]
  
  @logged_in = logged_in?
  @username = current_user if @logged_in
  @error = session[:error]
  erb :index
end

post '/' do
  erb :index
end

