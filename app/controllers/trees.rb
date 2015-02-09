get '/trees/:name' do
  user = session_current_user
  @tree = user.trees.find_by(name: params[:name])

  @depths = []
  depth = 0
  while true
    list = @tree.nodes_by_level(depth)
    if list.empty?
      break
    else
      @depths << list
      depth += 1
    end
  end

  erb :tree
end
