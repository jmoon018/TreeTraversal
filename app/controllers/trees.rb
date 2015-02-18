get '/trees/:name' do
  user = session_current_user
  if user == nil
	halt 401, "Log in please"
  end
  tree = user.trees.find_by(name: params[:name])

  if tree == nil
  	halt 404, "bad tree name"
  end


  @tree_info = {id: tree.id.to_s, name: tree.name, description: tree.description,
  	user_id: tree.user_id, 
	node_id: "null"}

  erb :list_tree_nodes
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

get '/trees/:name/test' do
	erb :list_tree_nodes
end

get '/trees/:name/json' do 
	content_type :json
	@nodes = Tree.find_by(name: params[:name]).get_all_nodes
	list = {}
	@nodes.each do |node| 
		node_obj = {}
		node_obj["value"] = node.value
		node_obj["node_id"] = node.node_id
		node_obj["id"] = node.id
		list[node.id] = node_obj
	end

	list.to_json
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
