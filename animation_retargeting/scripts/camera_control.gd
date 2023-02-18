extends SubViewport

@onready var general_camera_anchor = $GeneralCameraAnchor
@onready var general_camera = $GeneralCameraAnchor/Camera
@onready var side_camera = $SideCamera/Camera
@onready var top_camera = $TopCamera/Camera

var current_camera = null

func _ready():
	var t = create_tween().set_loops(0)
	t.tween_callback(switch_camera.bind(general_camera))
	t.tween_property(general_camera_anchor, "rotation_degrees:y", -55.0, 8.0).from(55.0)
	t.tween_callback(switch_camera.bind(side_camera))
	t.tween_property(side_camera, "position:z", 4.0, 4.0).from(6.0)
	t.tween_callback(switch_camera.bind(top_camera))
	t.tween_property(top_camera, "position:z", 6.0, 4.0).from(8.0)
	
func switch_camera(next_camera):
	if current_camera != null:
		current_camera.current = false
	current_camera = next_camera
	current_camera.current = true
