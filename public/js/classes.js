// Tree + Methods
function Tree(args) {
	this.id = args["id"];
	this.name = args["name"];
	this.description = args["description"];
	this.user_id = args["user_id"];
	this.node_id = args["node_id"]
	this.nodes = [];
};

// Draw from the bottom to the top
Tree.prototype.redraw = function() {
	while (true) {
		var depth = $(".nodes_depth_div").length();
		if (depth == 0) {
			break;
		}
		var depth_div = $(".nodes_depth_div").last();

		//var nodes
		depth_div.remove();	
	}
};

Tree.prototype.getNodeById = function(id) {
	for (var index = 0; index < this.nodes.length; index++) {
		if (this.nodes[index].id == id) {
			return this.nodes[index];
		}
	}
};

Tree.prototype.addChildToNode = function (parentId, childNode) {
	for (var index = 0; index < this.nodes.length; index++) {
		// check if we found the right node
		if (this.nodes[index].id == parentId) {
			this.nodes[index].children.push(childNode);
			break; //search is complete 
		}
	}
};

Tree.prototype.resetChildren = function() {
	for (var index = 0; index < this.nodes.length; index++) {
		this.nodes[index].children.length = 0; // proper way to reset
	}
};

Tree.prototype.resetView = function() {
	// Get the proper children now
	this.resetChildren();
	this.getChildren();
	$(".nodes_depth_div").remove();
	this.drawAllDepths();
};

Tree.prototype.getChildren = function() {

	for (var index = 0; index < this.nodes.length; index++) {
		var node = this.nodes[index];
		
		if (node.node_id != null) {
			console.log("Adding child [" + node.id + "] to parent [" + node.node_id + "]");
			this.addChildToNode(node.node_id, node);
		}
	}
};

Tree.prototype.populate = function(args) {
	for (var value in args) {
		var new_node = new Node(args[value]);
		this.nodes.push(new_node);
	}
	this.getChildren();
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
		var list = nodes_by_depth(depth, this.nodes[0]);
		if (list.length == 0) {
			break;
		}
		depth_list.push(list);
		depth++;
	}
	return depth_list;
};


// VIEW - METHODS KINDA 
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

Tree.prototype.addDepthHandlers = function() {
	// attach event handlers after adding the depths
	var tree = this;
	$(".nodes_depth_div").on("click", "p", function(event) {
		event.preventDefault();
		var obj = $(this);
		if (obj.is(".node_div")) {
			var node = tree.getNodeById(obj.data("id")); 
			tree.showNodeChange(node);
		}
	});
};


Tree.prototype.drawAllDepths = function() {
	nodes = this.all_nodes_by_depth(); // 2d array
	for (var depth = 0; depth < nodes.length; depth++) { 
		this.drawDepth(depth, nodes[depth]);
	}
	this.addDepthHandlers();
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
/*	var button = $("<a />", {
		href: "/node/" + this.id + "/edit",
		class: "node_link",
		title: "Edit node"
	});*/

	var text = $("<p />", {
		class: "node_div"
	});

	var parentIdSpan = $("<span />", {
		text: this.node_id
	});

	var valueSpan = $("<span />", {
		text: this.value
	});

	valueSpan.attr("spanNodeId", this.id);
	parentIdSpan.attr("parentIdSpan", this.id);
	text.attr("data-id", this.id);
	text.html("Node: " + this.id).append("<br>");
	text.append("Value: "); 
	text.append(valueSpan).append("<br>");
	text.append("Parent: ");
	text.append(parentIdSpan);

	return text;
};

Tree.prototype.updateNode = function(node) {
	var theTree = this;
	//var node = this;
	var url = "/node/" + this.id + "/update"; 

	// get the node's value from the text box with .val()
	var nodeValue = parseInt($("input[name='node_value']").val()); 
	var nodeParentId= parseInt($("input[name='node_parent_id']").val()); 
	var nodeId = node.id;

	var obj = $.ajax({
		url: url,
		dataType: "json",
		data: {nodeUpdateParentId: nodeParentId, 
			nodeUpdateValue: nodeValue, 
			nodeUpdateId: nodeId},
		type: "POST"
	});

	obj.done(function(data) {
		console.log(data);

		// update the node's actual value and print 
		node.value = data.value;
		node.node_id = data.parent_id;
		$("span[spannodeid='" + nodeId + "']").text(node.value);
		$("span[parentidspan='" + nodeId + "']").text(node.node_id);
		console.log("Updated data successfully");
		tree.resetView();
	});
	obj.fail(function(data) {
		console.log("Updated data -- failed");
	});
	$(".node_change_div").remove();
};

Tree.prototype.showNodeChange = function(node) {
	var theTree = this;
	//var node = this;

	// html for node's ID
	var nodeDiv = $("<div />", {
		class: "node_change_div"
	});

	var nodeIdDiv = $("<div />", {
		class: "node_change_field"
	});
	var nodeIdText = $("<p />", {
		class: "node_change_text",
		text: "Parent Node ID: "
	});
	var nodeIdInput = $("<input />", {
		type: "text",
		value: node.node_id,
		name: "node_parent_id"
	});
	
	// html for node's value
	var nodeValueDiv = $("<div />", {
		class: "node_change_field"
	});
	var nodeValueText = $("<p />", {
		class: "node_change_text",
		text: "Value: "
	});
	var nodeValueInput = $("<input />", {
		type: "text",
		value: node.value,
		name: "node_value"
	});

	// html for submit button
	var nodeSubmitButton = $("<button />", {
		class: "node_submit_button",
		text: "Submit."
	});

	nodeSubmitButton.click(function(event) {
		theTree.updateNode(node);
	});
	// press escape to remove the new window
	$(document).keyup(function(event) {
		if(event.keyCode == 27) {
			$(".node_change_div").remove();
		}
	});

	// add the node's id property / input
	nodeDiv.append(nodeIdDiv);
	nodeIdDiv.append(nodeIdText);
	nodeIdDiv.append(nodeIdInput);
	
	// add the node's value property / input
	nodeDiv.append(nodeValueDiv);
	nodeValueDiv.append(nodeValueText);
	nodeValueDiv.append(nodeValueInput);

	// add the button
	nodeDiv.append(nodeSubmitButton);
	console.log(nodeDiv);
	$("#center").append(nodeDiv);
};
