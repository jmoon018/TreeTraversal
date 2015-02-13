class Node < ActiveRecord::Base
  belongs_to :node
  has_many :nodes
  belongs_to :tree

  # A child must point to its parent, hence 'node_id: self.id'
  # for whatever reason, active record did not do this automatically
  def create_node (args = {})
    Node.create(node_id: self.id, value: args[:value], tree_id: nil)
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
end
