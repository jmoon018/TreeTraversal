get '/profile' do
  user = session_current_user

  if !session_logged_in?
    redirect to('/login')
  end
  @trees = user.trees
  erb :trees
end
