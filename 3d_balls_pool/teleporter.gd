extends Area3D


@export var _out_position_node : Node3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("balls"): 
		return
	var offset := body.global_position - global_position
	body.global_position = _out_position_node.global_position + offset
	body.linear_velocity.x = 0.0
	body.linear_velocity.z = 0.0
