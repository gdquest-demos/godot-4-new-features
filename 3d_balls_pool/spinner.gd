extends MeshInstance3D


func _physics_process(delta):
	rotate_y(0.8 * delta)
