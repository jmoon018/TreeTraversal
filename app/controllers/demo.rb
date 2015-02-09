get '/demo' do
  puts "LEL"
  puts session[:error]
  erb :demo
end
