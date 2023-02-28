extends Node3D

@export var target_transform : Node3D
var camera : Camera3D = null


func _process(_delta: float) -> void:
	# in certain conditions, the cam can be deleted by navigating to another 3D
	# scene from the menu
	if not camera:
		camera = get_viewport().get_camera_3d()
	var cam_pos := camera.global_transform.origin
	var relative_pos := cam_pos - target_transform.global_transform.origin
	var dot := target_transform.global_transform.basis.z.dot(relative_pos)
	if dot < 0:
		hide()
	else:
		show()
