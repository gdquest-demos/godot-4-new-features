extends Node2D

var current_node : Node2D = null : set = _set_current_node
var current_group : Node2D = null
var group_map := {}


func _ready() -> void:
	current_group = get_child(0)
	for node: Node in get_children(false):
		group_map[node.name] = node
		for childs in node.get_children():
			childs.hide()
	reset()


func set_group(group_name : String):
	if not group_map.has(group_name):
		return
	current_group = group_map[group_name]
	reset()


## Reset node to default group node
## (Default node is first node)
func reset():
	current_node = current_group.get_child(0)


## Set a random node in group
func set_random():
	current_node = current_group.get_children().pick_random()


func _set_current_node(node : Node2D):
	if current_node: current_node.hide()
	current_node = node
	current_node.show()
