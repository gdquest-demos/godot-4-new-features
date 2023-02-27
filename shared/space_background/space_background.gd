extends ColorRect


func _ready():
	connect("resized", _set_ratio)
	_set_ratio()

func _set_ratio():
	material.set("shader_parameter/bg_ratio", Vector2(1.0, size.y / size.x))
