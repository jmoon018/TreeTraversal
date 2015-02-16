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
		var list = nodes_by_depth(depth, this.nodes[this.node_id]);
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
			var node = tree.nodes[obj.get(0).dataset["id"]];
			node.showNodeChange();
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

	var valueSpan = $("<span />", {
		text: this.value
	});

	valueSpan.attr("spanNodeId", this.id);
	text.attr("data-id", this.id);
	text.html("Node: " + this.id).append("<br>");
	//text.append("Value: " + this.value).append("<br>");
	text.append("Value: "); 
	text.append(valueSpan).append("<br>");
	text.append("Parent: " + this.node_id);

	return text;
};

Node.prototype.updateNode = function() {
	var node = this;
	var url = "/node/" + this.id + "/update"; 

	// get the node's value from the text box with .val()
	var nodeValue = parseInt($("input[name='node_value']").val()); 
	var nodeId = this.id;

	var obj = $.ajax({
		url: url,
		dataType: "json",
		data: {nodeUpdateValue: nodeValue, nodeUpdateId: nodeId},
		type: "POST"
	});

	obj.done(function(data) {
		console.log(data);

		// update the node's actual value and print 
		node.value = data.value;
		$("span[spannodeid='" + nodeId + "']").text(node.value);
		console.log("Updated data successfully");
	});
	obj.fail(function(data) {
		console.log("Updated data -- failed");
	});
	$(".node_change_div").remove();
};

Node.prototype.showNodeChange = function() {
	var node = this;

	// html for node's ID
	var nodeDiv = $("<div />", {
		class: "node_change_div"
	});

	var nodeIdDiv = $("<div />", {
		class: "node_change_field"
	});
	var nodeIdText = $("<p />", {
		class: "node_change_text",
		text: "Node ID: "
	});
	var nodeIdInput = $("<input />", {
		type: "text",
		value: node.id,
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
		node.updateNode();
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
