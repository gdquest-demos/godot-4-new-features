extends Node3D

@export var low_angle : float = -5.0
@export var high_angle : float = -50.0

@export var rotation_limit_start : float = -65.0
@export var rotation_limit_end : float = -15.0

@export var min_zoom : float = 1.0
@export var max_zoom : float = 2.0
@onready var _camera: Camera3D = %Camera3D
var _is_grabbing := false


func _unhandled_input(event: InputEvent) -> void:
	var wheel_direction := 0.0
	if (event is InputEventMouseButton): 
		if event.button_index == MOUSE_BUTTON_RIGHT: _is_grabbing = event.pressed
		var wheel_up: bool = event.button_index == MOUSE_BUTTON_WHEEL_UP
		var wheel_down: bool = event.button_index == MOUSE_BUTTON_WHEEL_DOWN
		
		wheel_direction = float(wheel_down) - float(wheel_up)
	
	if wheel_direction != 0:
		_camera.position.z += wheel_direction * 0.25
		_camera.position.z = clamp(_camera.position.z, min_zoom, max_zoom)
		
	# Check mouse motion
	if (event is InputEventMouseMotion):
		if not _is_grabbing: return
		rotation.y += -event.relative.x * 0.005
		rotation.x += -event.relative.y * 0.005
		rotation.y = clamp(rotation.y, deg_to_rad(rotation_limit_start), deg_to_rad(rotation_limit_end))
		rotation.x = clamp(rotation.x, deg_to_rad(high_angle), deg_to_rad(low_angle))
