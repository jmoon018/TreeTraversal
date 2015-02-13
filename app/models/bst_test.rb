require_relative "bst.rb"

def test_1
	puts "hi"
	node1 = BST_Node.new(9251)
	node2 = BST_Node.new(501)
	node3 = BST_Node.new(10235)
	node4 = BST_Node.new(888)
	node5 = BST_Node.new(777)
	node6 = BST_Node.new(999)

	node1.left_child = node2
	node2.parent = node1

	node1.right_child = node3
	node3.parent = node3

	node4.parent = node2
	node2.right_child = node4

	node5.parent = node4
	node4.left_child = node5

	node4.right_child = node6
	node6.parent = node4

	node1.print_in_order
	node1.delete_it(888)
	puts "AFTER DELETING:"
	node1.print_in_order

	puts "hi"
end

def test_2
	node1 = BST_Node.new(9251)
	node2 = BST_Node.new(501)
	node3 = BST_Node.new(10235)
	node4 = BST_Node.new(888)
	node5 = BST_Node.new(777)
	node6 = BST_Node.new(999)

	node1.left_child = node2
	node2.parent = node1

	node1.right_child = node3
	node3.parent = node3

	node4.parent = node2
	node2.right_child = node4

	node5.parent = node4
	node4.left_child = node5

	node4.right_child = node6
	node6.parent = node4
	
	
end
