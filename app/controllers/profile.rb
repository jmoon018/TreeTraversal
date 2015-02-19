get '/profile' do
  if !logged_in?
    redirect to('/login')
  end
  @trees = current_user.trees
  erb :trees
end
