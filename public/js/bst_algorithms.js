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
	this.root = null; //this.nodes[0];
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


// PSUEODOCODE:
// If the current node's val is bigger than value, go left
// If the current node's val is smaller than value, go right
// Ends when you reach a external node
// Note: when a duplicate node is discovered, it goes to left subtree
BST.prototype.insert = function(value) {
	var root = bst.nodes[0];
	console.log("Attempting to insert the value (" + value + ") into BST (" + this.name + ")");
	root.insert(value);
};


BST_Node.prototype.insert = function(value) {
	if (value > this.value) {
		if (this.right == null) {
			this.right = new BST_Node({value: value});
		}
		else {
			
			this.right.insert(value);
		}
	}
	else if (value <= this.value) {
		if (this.left == null) {
			this.left = new BST_Node({value: value});
		}
		else {
			this.left.insert(value);
		}
	}
};


BST_Node.prototype.replaceValues = function(node2) {

	if (node2 == null) {
		return false;
	}
	this.id = node2.id;
	this.value = node2.value;
	this.left = node2.left;
	this.right = node2.right;
};

BST.prototype.remove = function(value) {
	var root = bst.nodes[0];
	var replacementNode = root.remove(value, null);
	// check if we are removing the root, if so we have to do special stuff
	if (root.value == value) {
		this.root = replacementNode;
		bst.nodes[0] = replacementNode;
	}
	return replacementNode;
};

// if the value does not exist, return false
// if it does, remove it, do adjustments etc and return the replacement node

// STEPS: 
// find the value, if not found, return false
// when found:
//	- No children: just remove the node
//	- One child: remove taht node and replace it with its child
//	- Two children: get the in-order successor

// HURRAY MEMORY LEAKS COUGH
// keep track of parent node.. makes my life much much easier
BST_Node.prototype.remove = function (value, parentNode) {
	if (value > this.value) {
		if (this.right == null) {
			return false; // value does not exist
		}
		else {
			return this.right.remove(value, this);
		}
	}
	else if (value < this.value) {
		if (this.left == null) {
			return false;
		}
		else {
			return this.left.remove(value, this);
		}
	}
	// ok found the node
	else { 
		if (this.left == null && this.right == null) {
			if (parentNode.left.value == this.value) {
				parentNode.left = null;
			}
			else { 
				parentNode.right = null;
			}
			return null;
		}
		else if (this.left == null) {
			if (parentNode.left.value == this.value) { 
				parentNode.left = this.right;
			}
			else {
				parentNode.right = this.right;
			}
			//var leftNode = this.left;
			//this.replaceValues(this.left); // 'replace'
			return this.right;
		}
		else if (this.right == null) {
			if (parentNode.left.value == this.value) {
				parentNode.left = this.left;
			}
			else {
				parentNode.right = this.left;
			}
			//this.replaceValues(this.right); // 'replace'
			return this.left;
		}
		else {
			// choose the in-order successor
			// make a method for this later pls	
			var successorParent = this;
			var successor = this.left;
			while (successor.right != null) {
				successorParent = successor;
				successor = successor.right;
			}

			// case 1 -- the in-order successor is the node's left 
			if (successor == this.left) { 
				this.left.right = this.right;
				return this.left;
			}
			
			// keep the left node -- will need it soon
			var successorLeftNode = successor.left; // could be null, does not matter
			//this.left = successorParent;
			successor.left = this.left;
			successor.right = this.right;
			this.left.right = this.successorLeftNode;

			if (parentNode == null) {
				return successor;
			}
			else if (parentNode.left.value == this.value) {
				parentNode.left = successor;
			}
			else {
				parentNode.right = successor;
			}
			return successor; 
		}
	}
};


// all global variables so i can play with them in the console
function seedSampleBST() {
	bst = new BST({id: 1, name: "BST TREE", description: "WHO NEEDS A DESCRIPTION"});
	bst_node1 = new BST_Node({id: 1, value: 10});
	bst_node2 = new BST_Node({id: 2, value: 15});
	bst_node3 = new BST_Node({id: 3, value: 5});
	bst_node4 = new BST_Node({id: 4, value: 0});
	//bst_node5 = new BST_Node({id: 5, value: 7});

	bst.root = bst_node1;
	bst.nodes.push(bst_node1);
	bst_node1.right = bst_node2;
	bst_node1.left = bst_node3;
	bst_node3.left = bst_node4;
	bst.insert(7);
};

seedSampleBST();

