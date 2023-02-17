extends Node3D

@export var low_angle : float = -10.0
@export var high_angle : float = -40.0

var _is_grabbing := false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: 
		_is_grabbing = event.pressed
	# Check mouse motion
	if not (event is InputEventMouseMotion):
		return
	if not _is_grabbing: 
		return
	
	rotation.y += -event.relative.x * 0.005
	rotation.x += -event.relative.y * 0.005
	rotation.x = clamp(rotation.x, deg_to_rad(high_angle), deg_to_rad(low_angle))
