extends Node3D

@export var target_transform : Node3D
var camera : Camera3D = null

func _ready() -> void:
	camera = get_viewport().get_camera_3d()

func _process(_delta: float) -> void:
	var cam_pos := camera.global_transform.origin
	var relative_pos := cam_pos - target_transform.global_transform.origin
	var dot := target_transform.global_transform.basis.z.dot(relative_pos)
	if dot < 0:
		hide()
	else:
		show()
