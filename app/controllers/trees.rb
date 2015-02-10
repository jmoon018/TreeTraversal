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

