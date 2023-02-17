extends Camera3D


func _process(_delta: float) -> void:
	var t := Time.get_ticks_msec() / 1000.0
	position.x = sin(t) * 0.25
	position.y = sin(t * 10.0) * 0.08
	rotation.x = sin(t * 10.0) * 0.01
	rotation.z = sin(t * 2.0) * 0.05
