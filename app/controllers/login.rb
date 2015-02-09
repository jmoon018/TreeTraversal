put '/login' do
  # login if possible
  username = params[:username]
  password = params[:password]

  puts "REQUEST TO LOGIN: #{username}"
  if session_authenticate(username, password)
    puts "LOGIN SUCCESSFUL!"
    session[:error] = ""
    session_set_current_user ( User.find_by(name: username) )
  else
    puts "LOGIN NOT SUCCESSFUL!"
    session[:error] = "Unsuccessful login."
  end

  redirect to('/')
end

get '/logout' do
  session_logout
  redirect to('/')
end
