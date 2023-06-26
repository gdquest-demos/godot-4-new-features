extends Node3D

@export_range(0.0, 90.0, 5.0) var low_angle : float = 45.0
@export_range(0.0, 90.0, 5.0) var high_angle : float = 45.0

@export var min_zoom : float = 1.0
@export var max_zoom : float = 10.0

@export var default_zoom : float = 5.0

@onready var camera_3d = %Camera3D

var is_grabbing = false

func _ready():
	camera_3d.position.z = default_zoom
	rotation_degrees.y = -45.0
	rotation_degrees.x = -25.0

func _unhandled_input(event):
	var wheel_direction = 0.0
	if (event is InputEventMouseButton): 
		if event.button_index == MOUSE_BUTTON_LEFT: is_grabbing = event.pressed
		var wheel_up = event.button_index == MOUSE_BUTTON_WHEEL_UP
		var wheel_down = event.button_index == MOUSE_BUTTON_WHEEL_DOWN
		wheel_direction = float(wheel_down) - float(wheel_up)
	
	if wheel_direction != 0:
		camera_3d.position.z += wheel_direction * 0.25
		camera_3d.position.z = clamp(camera_3d.position.z, min_zoom, max_zoom)
		
	if (event is InputEventMouseMotion):
		if !is_grabbing: return
		rotation.y += -event.relative.x * 0.005
		rotation.x += -event.relative.y * 0.005
		rotation.x = clamp(rotation.x, deg_to_rad(-high_angle), deg_to_rad(low_angle))
