get '/login' do
  if logged_in?
    redirect to('/profile')
  end
  erb :login
end

put '/login' do
  # login if possible
  username = params[:username] 
  password = params[:password]

  puts "REQUEST TO LOGIN: #{username}"
  if authenticate(username, password)
    puts "LOGIN SUCCESSFUL!"
    session[:error] = ""
  else
    puts "LOGIN NOT SUCCESSFUL!"
    session[:error] = "Unsuccessful login."
  end

  redirect back
end

get '/logout' do
  logout
  redirect to('/')
end
