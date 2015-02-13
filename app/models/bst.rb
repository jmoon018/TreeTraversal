class BST_Node 
	attr_accessor :value, :left_child, :right_child, :parent
	def initialize (value)
		@value = value
		@left_child = nil
		@right_child = nil
		@parent = nil
	end


	def insert (value, node) 
		if node == nil
			node = BST_Node.new(value)
		elsif value <= node.value # go left
			insert(value, node.left_child)
		elsif value > node.value # go right
			insert(value, node.right_child)
		end
	end

	# Move once left, then continue going right if possible
	def in_order_predecessor
		current_node = @left_child
		while current_node.right_child != nil
			current_node = current_node.right_child
		end
		return current_node
	end

	def replace_node_in_parent (new_value)
		if @parent != nil
			if self == self.parent.left_child
				self.parent.left_child = new_value
			else 
				self.parent.right_child = new_value
			end
		end
		if new_value != nil
			new_value.parent = @parent
		end
	end

	def delete_it (value)
		puts "Deleting #{value} ... Current node: #{@value}"
		if @value > value 
			@left_child.delete_it(value)
		elsif @value < value 
			@right_child.delete_it(value)
		else
			puts "found it"
			# found the proper value, delete it

			# both children exist
			if @left_child != nil && @right_child != nil
				puts "both children yo"
				predecessor = in_order_predecessor
				puts "predecessor value: #{predecessor.value}"
				@value = predecessor.value
				predecessor.delete_it(predecessor.value)
			elsif @left_child != nil # only right child exists
				replace_node_in_parent(@left_child)
			elsif @right_child != nil # only left child exists
				replace_node_in_parent(@right_child)
			else # no children
				replace_node_in_parent(nil)
			end
		end
	end

	def print_in_order
		if @left_child != nil
			@left_child.print_in_order
		end
		puts @value
		if @right_child != nil
			@right_child.print_in_order
		end
	end
end
