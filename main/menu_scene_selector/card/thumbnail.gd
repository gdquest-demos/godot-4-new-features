extends TextureRect

var current_zoom = 1.0 : set = _set_current_zoom
var current_gradient_opacity = 0.0 : set = _set_current_gradient_opacity

func _ready():
	connect("resized", _set_ratio)

func _set_current_zoom(value : float):
	current_zoom = value
	if not is_inside_tree():
		await ready
	var t = create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(material, "shader_parameter/zoom", current_zoom, 0.1)

func _set_current_gradient_opacity(value : float):
	current_gradient_opacity = value
	var t = create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(material, "shader_parameter/gradient_opacity", current_gradient_opacity, 0.1)

func _set_ratio():
	material.set("shader_parameter/ratio", Vector2(size.x/size.y, 1.0))

func set_texture_ratio():
	var s = texture.get_size()
	material.set("shader_parameter/texture_ratio", Vector2(s.y/s.x, 1.0))
