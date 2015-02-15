// Tree + Methods
function Tree(args) {
	this.id = args["id"];
	this.name = args["name"];
	this.description = args["description"];
	this.user_id = args["user_id"];
	this.node_id = args["node_id"]
	this.nodes = {};
};

Tree.prototype.populate = function(args) {
	for (var value in args) {
		var new_node = new Node(args[value]);
		this.nodes[value] = new_node;
		console.log("Node id: " + args[value]["node_id"]);
		if (args[value]["node_id"] != null) {
			this.nodes[args[value]["node_id"]].children.push(new_node);
		}
	}
};




// a helper, I suppose
function nodes_by_depth(depth, node) {
	if (depth == 0) {
		return [node];
	}
	else {
		var list = [];
		for (var i = 0; i < node.children.length; i++) {
			list.push(nodes_by_depth(depth-1, node.children[i]));
		}
		var flatten = [];
		flatten = flatten.concat.apply(flatten, list);
		return flatten;
	}
};

// Tree.all_nodes_by_depth
Tree.prototype.all_nodes_by_depth  = function() {
	var depth = 0;
	var depth_list = []; // 2D array: each element is the nodes at the element's index depth
	while (true) {
		var list = nodes_by_depth(depth, this.nodes[1]);
		if (list.length == 0) {
			break;
		}
		depth_list.push(list);
		depth++;
	}
	return depth_list;
};


// VIEW - METHODS KINDA 
Tree.prototype.make_html = function() {
	for (var i = 0; i < this.nodes.length; i++) {
		this.nodes[i].draw_node();	
	}
};

Tree.prototype.drawDepth = function(depth, nodes) { 
	var depthDiv = $("<div />", {
		class: "nodes_depth_div"
	});

	var headerElem = $("<h3 />", {
		class: "node_depth_title",
		text: ("Depth " + depth)
	});

	depthDiv.append(headerElem);

	for (var i = 0; i < nodes.length; i++) {
		depthDiv.append(nodes[i].getNodeHtml());
	}

	$('#center').append(depthDiv);
};

Tree.prototype.drawAllDepths = function() {
	nodes = this.all_nodes_by_depth(); // 2d array
	for (var depth = 0; depth < nodes.length; depth++) { 
		this.drawDepth(depth, nodes[depth]);
	}
};


// NODE FUNCTIONS
//========================================

function Node(args) {
	this.value = args["value"];
	this.id = args["id"];
	this.node_id = args["node_id"];
	this.children = []; // this will contain the list of IDs this node's children
};

Node.prototype.getNodeHtml = function(selector) {
	console.log("TRYING TO MAKE HTML");
	var button = $("<a />", {
		href: "/node/" + this.id + "/edit",
		class: "node_link",
		title: "Edit node"
	});

	var text = $("<p />", {
		class: "node_div"
	});
	text.html("Node: " + this.id).append("<br>");
	text.append("Value: " + this.value).append("<br>");
	text.append("Parent: " + this.node_id);

	button.append(text);
	//$(selector).append(button);
	return button;
};


function do_stuff () { 
	console.log(button);
	var t = document.createTextNode("BUTTON!!!");
	console.log(t);
	button.appendChild(t);
	var elem = $("<a />", {
		href: "/node/1/edit",
		class: "node_link",
		title: "Edit node",
	});

	// Setup the text
	var para = $("<p />");

	elem.append(para);
	$("#buttons_id").append(elem);
	console.log("created a div");
};
