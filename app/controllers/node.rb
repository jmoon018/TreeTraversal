get '/node/new' do
  erb :node
end

put '/node/new' do

end


get '/node/:id/edit' do
  @node = Node.find(params[:id])
  @node_value = "nil"
  @node_parent_id = "nil"
  if @node == nil
    puts "Trying to edit node #{params[:id].to_s} [get] but it is nil"
  else
    @node_value = @node.value || "nil"
    @node_parent_id = @node.node.id if @node.node != nil
  end
  @msg = "Edit Node # #{params[:id]}"
  @action = "/node/#{params[:id].to_s}/edit"
  erb :node
end

put '/node/:id/edit' do
  id = params[:id]
  puts "Attempting to edit Node ##{id}"
  @node = Node.find(id)
  if @node == nil
    puts "Node #{id} not found. It is nil. :("
    redirect back
  else
    puts "Updating Node #{id}"
    parent = params[:node_parent_id]
    parent = nil if parent == "nil"

    value = params[:node_value]
    value = nil if value == "nil"
    @node.update(value: value, node_id: parent)
	tree_name = Tree.find(session[:tree_id]).name
	tree_name.gsub!(" ", "%20")
    redirect to("/trees/" + tree_name)
  end
end
