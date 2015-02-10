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
