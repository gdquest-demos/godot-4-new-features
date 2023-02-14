extends SpotLight3D

@export var target : Node3D

func _process(delta):
	look_at(target.global_position, Vector3.UP)
