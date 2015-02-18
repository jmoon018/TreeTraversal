jsPlumb.ready(function() {
	console.log("READY");
	
	var instance = jsPlumb.getInstance({
		Connector: ["Bezier", { curviness: 80 }],
		Anchors: ["TopCenter", "BottomCenter"],
		DragOptions: {cursor: "pointer", zIndex:2000 },
		PaintStyle: { strokeStyle: "black", lineWidth: 3},
		EndpointStyle: { radius:5, fillStyle: "black" },
		HoverPaintStyle: { strokeStyle: "orange" },
		EndpointHoverStyle: { strokeStyle: "blue" },
		Container: "visuals_background"
	});

	instance.doWhileSuspended(function() {
		var arrow = {foldback: .7, fillStyle: "black", width: 20 },
			overlays = [
				["Arrow", { location: 0.95 }, arrow ]
				//["Arrow", { location: 0.3, direction:-1 }, arrow]
			];
			var nodeWindows = $(".node");
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

			
			instance.connect({uuids: ["nodeWindow1-bottom", "nodeWindow2-top" ], overlays:overlays});
			instance.connect({uuids: ["nodeWindow1-bottom", "nodeWindow3-top" ], overlays:overlays});

			instance.draggable(nodeWindows);
	});
});
