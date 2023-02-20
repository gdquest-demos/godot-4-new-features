extends ColorRect

func _ready() -> void:
	_set_ratio()
	connect("resized", _set_ratio)

func _set_ratio() -> void:
	var ratio := size.y / size.x
	material.set_shader_parameter("ratio", ratio)
