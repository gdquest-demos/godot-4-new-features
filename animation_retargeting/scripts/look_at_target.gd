extends SpotLight3D

@export var target : Node3D

func _process(_delta: float) -> void:
	look_at(target.global_position, Vector3.UP)
