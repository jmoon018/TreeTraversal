MIN_INT = -2_147_483_648
MAX_INT = 2_147_483_647 # a friendly reminder that you wasted an hour before figuring out that sh-t wasn't supposed to be positive.. never forget


class Tree < ActiveRecord::Base
  belongs_to :user
  has_one :node


  def create_node (arg = {})
	Node.create(tree_id: self.id, value: arg[:value], node_id: nil)
  end
  # node count
  def node_count
    #depth_first_search.count
	get_all_nodes.count	
  end

  def get_all_nodes
	Node.where(tree_id: self.id)		
  end

  # default is root
  def depth_first_search(node = self.node)
    # base case
    if node.nodes.empty?
      return [node]
    else
      theReturn = [node]
      node.nodes.each {|n| theReturn = theReturn + depth_first_search(n)}
      return theReturn
    end
  end

  # this is a breadth first search
  def nodes_by_level (depth, node = self.node)
    if depth == 0
      return [node]
    elsif !node.nodes.empty?
      nodes = []
      node.nodes.each {|n| nodes = nodes + nodes_by_level(depth-1, n)}
      return nodes
    else
      return []
    end
  end

  # Return the minimax value of a node
  def minimax (args)
    node = args[:node] || self.node
    depth = args[:depth] || 10
    maximize_it = args[:maximize]
    value = node.value
    nodes = node.nodes

    if nodes.empty? || depth == 0
      return node.value

    # we want to pick the child with the HIGHEST value
    elsif maximize_it
      biggest_value = MIN_INT
      nodes.each do |child_node|
        value = minimax({node: child_node, maximize: false, depth: depth-1})
        # pick the bigger of the two
        biggest_value =  [value, biggest_value].max
      end
      return biggest_value

    # we want to pick the child with the SMALLEST value
    elsif !maximize_it
      smallest_value = MAX_INT
      nodes.each do |child_node|
        value = minimax({node: child_node, maximize: true, depth: depth-1})
        smallest_value = [value, smallest_value].min
      end
      return smallest_value
    end
  end


  # THE NEXT OPERATIONS ARE ASSUME FOR A BINARY SEARCH TREE
  # let's assume that we are taking a node as an argument
  # later, we can take an integer, and create a node as a result
  def insert (node, root = self.node)  
  	if root == nil
  		self.update(node: node)
	elsif node.value < root.value
		insert(node, root.children.first)
	elsif node.value > root.value
		insert(node, root.children.first)
	end
  end
end
