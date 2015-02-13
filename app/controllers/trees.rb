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
  @minimax_value = @tree.minimax({maximize: true})
  @dfs_values = (@tree.depth_first_search.map {|n| n.id}).join(", ")
  @node_count = @tree.node_count
  session[:tree_id] = @tree.id

  erb :tree
end

get '/trees' do
  user = session_current_user
  @trees = user.trees
  erb :trees
end

get '/trees/:name/edit' do
  @tree_name = params[:name]
  tree = Tree.find_by(name: @tree_name)
  if tree == nil
    puts "Trying to find tree #{name} but not found"
    return
  end
  @user_id = tree.user.id
  @description = tree.description
  @root_id =  tree.node.id


  erb :trees_edit
end

post '/trees/:name/edit' do 
	# update the tree in the database 
	name = params[:tree_name]
	user_id = params[:user_id]
	root_id = params[:root_id]
	description = params[:description]

	tree = Tree.find(session[:tree_id])
	puts "Updating a tree: " + session[:tree_id].to_s
	tree.update(name: name, user_id: user_id, node_id: root_id, description: description);

	redirect to('/trees')
end





