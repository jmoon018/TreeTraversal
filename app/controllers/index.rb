enable :sessions

get '/' do
  @user_id = session[:current_user_id]
  @username = User.find(@user_id).name if @user_id != nil
  @logged_in = (@user_id != nil)
  @error = session[:error]
  erb :index
end

post '/' do
  erb :index
end

