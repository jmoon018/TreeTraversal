class Node < ActiveRecord::Base
  belongs_to :node
  has_many :nodes
  belongs_to :tree

  # A child must point to its parent, hence 'node_id: self.id'
  # for whatever reason, active record did not do this automatically
  def create_node (args = {})
    Node.create(node_id: self.id, value: args[:value], tree_id: self.tree_id)
  end


  # to do: make this 12351965 more efficient pls
  def print_in_order
	list = []
	left = self.nodes.where("value < ?", self.value)
	right = self.nodes.where("value > ?", self.value)

	if !left.empty?
		list = list + left.first.print_in_order
	end
	list = list + [self.value]
	if !right.empty?
		list = list + right.first.print_in_order
	end
	return list
  end


  def insert (value)
	left = self.nodes.where("value < ?", self.value).first
	right = self.nodes.where("value > ?", self.value).first
	
	# determine direction to go
	if self.value < value
		if right == nil # base case
			self.create_node(value: value)
		else
			right.insert(value)
		end
	elsif self.value > value
		if left == nil # base case
			self.create_node(value: value)
		else
			left.insert(value)
		end
	end
  end

  def get_right_child 
  	self.nodes.where("value > ?", self.value).first
  end

  def get_left_child
	self.nodes.where("value < ?", self.value).first
  end

  # TODO: optimize.. LOL
  def get_predecessor (value=self.value)
  	cur_node = get_left_child
	return self if cur_node == nil

	while cur_node.get_right_child != nil
		cur_node = cur_node.get_right_child
	end
	return cur_node
  end

  def get_parent (value, last_visited = nil)
	left = get_left_child
	right = get_right_child

	return last_visited if self.value == value
	if value < self.value
		return left.get_parent(value, self)
	elsif value > self.value
		return right.get_parent(value, self)
	end	
  end

  def delete (value)
	predecessor = get_predecessor(value)
	right_child = get_right_child
	left_child = get_left_child
	pre_parent = get_parent(value)
	return false
  end
end
