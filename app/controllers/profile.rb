get '/profile' do
  user = session_current_user
  @trees = user.trees
  erb :profile
end
