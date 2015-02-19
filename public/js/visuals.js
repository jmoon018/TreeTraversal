

// instance is the jsPlumb instance
// node1 is the top node
// node2 is the bottom node
function connectNode(instance, node1, node2) {
	console.log("Connecting node1 (" + node1 + ") to node2 (" + node2 + ")");
	var uuid1 = "node_div" + node1.id + "-bottom";
	var uuid2 = "node_div" + node2.id + "-top";
	instance.connect({uuids: [uuid1, uuid2]}); 
};

function connectAllNodes(tree, instance) {
	var nodeDivs = $("[class^=node_div]");
	//var completed = {}
	for (var i = 0; i < nodeDivs.length; i++) {
		// have to get the javascript object, not the HTML obj
		var node = tree.getNodeById(nodeDivs[i].dataset["id"]);
		console.log("Node: " + node.id);
		var children = node.children;
		for (var j = 0; j < children.length; j++) {
			connectNode(instance, node, children[j]);
		}
	};
}

function startJSPlumb(tree) {
	console.log("WHAT");
	jsPlumb.ready(function() {
		console.log("READY");
		
		// global so we can test in console
		instance = jsPlumb.getInstance({
			Connector: ["Bezier", { curviness: 80 }],
			Anchors: ["TopCenter", "BottomCenter"],
			DragOptions: {cursor: "pointer", zIndex:2000 },
			PaintStyle: { strokeStyle: "black", lineWidth: 3},
			EndpointStyle: { radius:5, fillStyle: "black" },
			HoverPaintStyle: { strokeStyle: "orange" },
			EndpointHoverStyle: { strokeStyle: "blue" },
			Container: "center"
		});

		instance.doWhileSuspended(function() {
			var arrow = {foldback: .7, fillStyle: "black", width: 20 },
			overlays = [
			["Arrow", { location: 0.95 }, arrow ]
			];
		var nodeWindows = $(".node_div");
		for (var i = 0; i < nodeWindows.length; i++) {
			instance.addEndpoint(nodeWindows[i], {
				uuid: nodeWindows[i].getAttribute("id") + "-bottom",
				anchor: "Bottom",
				maxConnections: -1
			});
			instance.addEndpoint(nodeWindows[i], {
				uuid: nodeWindows[i].getAttribute("id") + "-top",
				anchor: "Top",
				maxConnections: -1
			});
		}
		connectAllNodes(tree, instance);
		instance.draggable(nodeWindows);
		tree.jsPlumbInstance = instance;
		});
	});
}

