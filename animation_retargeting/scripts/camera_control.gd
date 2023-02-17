extends SubViewport

@onready var _general_camera_anchor: Node3D = %GeneralCameraAnchor
@onready var _general_camera: Camera3D = %GeneralCamera
@onready var _side_camera: Camera3D = %SideCamera
@onready var _top_camera: Camera3D = %TopCamera

var current_camera: Camera3D = null

func _ready() -> void:
	var t := create_tween().set_loops(0)
	t.tween_callback(switch_camera.bind(_general_camera))
	t.tween_property(_general_camera_anchor, "rotation_degrees:y", -55.0, 8.0).from(55.0)
	t.tween_callback(switch_camera.bind(_side_camera))
	t.tween_property(_side_camera, "position:z", 4.0, 4.0).from(6.0)
	t.tween_callback(switch_camera.bind(_top_camera))
	t.tween_property(_top_camera, "position:z", 6.0, 4.0).from(8.0)
	
func switch_camera(next_camera: Camera3D) -> void:
	if current_camera != null:
		current_camera.current = false
	current_camera = next_camera
	current_camera.current = true
