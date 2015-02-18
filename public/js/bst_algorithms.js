//console.log("swag");
//function BST(args) {
//	var bs_tree = Object.create(Tree,	
//};

//BST.inherits(tree);


//bst = new BST({id: 1, name: "Tree", description: "the description", user_id: 1, node_id: 1});
/*
function Animal(name) {
	this.name = name;
}

Animal.prototype.speak = function() {
	console.log("My name is " + this.name);
};

function Cat(name) {
	Animal.call(this, name);
}

Cat.prototype = new Animal();
Cat.prototype.meow = function() {
	console.log("MEOW!");
};

var anim = new Animal('Da Animal');
var cat = new Cat('Monty');

anim.speak();
cat.speak();
cat.meow();
*/

// INHERITANCE YAY! [must study more]
var BST = function(args) {
	Tree.apply(this,arguments); // create and assign properties from Tree
	console.log("CREATING A BST!"); // print a success msg 
}
BST.prototype = Tree.prototype; // use the Tree's prototype
BST.prototype.constructor = BST; // make sure the constructor is BST's


// MORE INHERITANCE
var BST_Node = function(args) {
	Node.apply(this,arguments);
	this.left = null;
	this.right = null;
	console.log("CREATING A BST NODE!");
}

BST_Node.prototype = Node.prototype;
BST_Node.prototype.constructor = Node;



//bst = new BST({id: 1, name: "BST TREE", description: "WHO NEEDS A DESCRIPTION"})

// PSUEODOCODE:
// if value > curNode.value
//		search right
// else if value < curNude.value 
// 		search left
// else 
//		return node

BST.prototype.search = function(value) {
	// get the root node and call search on it
	var root = bst.nodes[0]; // assuming root is 0 [for now]
	console.log("Attempting a search for " + value + " in BST [" + this.name + "]");
	return root.search(value);
};

BST_Node.prototype.search = function(value) {
	var that = this;
	//console.log("Attempting a search for " + value + " in BST node");
	// the current node's value is too small --> go right
	if (value > this.value) {
		// console.log("RIGHT");
		// no right child -- so the value does not exist
		if (this.right == null) {
			return false;
		}
		else {
			return this.right.search(value);
		}
	}
	// the current node's value is too big --> go left
	else if (value < this.value ) {
		// console.log("LEFT");
		// no left child -- so the value does not exist
		if (this.left == null) {
			return false;
		}
		else {
			return this.left.search(value);
		}
	}
	// value matches -- return the node
	else {
		return this;
	}
};


// all global variables so i can play with them in the console
function seedSampleBST() {
	bst = new BST({id: 1, name: "BST TREE", description: "WHO NEEDS A DESCRIPTION"});
	bst_node1 = new BST_Node({id: 1, value: 10});
	bst_node2 = new BST_Node({id: 2, value: 15});
	bst_node3 = new BST_Node({id: 3, value: 5});
	bst_node4 = new BST_Node({id: 4, value: 0});

	bst.nodes.push(bst_node1);
	bst_node1.right = bst_node2;
	bst_node1.left = bst_node3;
	bst_node3.left = bst_node4;
};

seedSampleBST();

