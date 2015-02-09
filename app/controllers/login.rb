get '/login' do
  if session_logged_in?
    redirect to('/profile')
  end
  erb :login
end

put '/login' do
  # login if possible
  username = params[:username] || params[:username2]
  password = params[:password] || params[:password2]

  puts "REQUEST TO LOGIN: #{username}"
  if session_authenticate(username, password)
    puts "LOGIN SUCCESSFUL!"
    session[:error] = ""
    session_set_current_user ( User.find_by(name: username) )
  else
    puts "LOGIN NOT SUCCESSFUL!"
    session[:error] = "Unsuccessful login."
  end

  redirect back
end

get '/logout' do
  session_logout
  redirect to('/')
end
