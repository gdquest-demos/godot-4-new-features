extends Camera2D

var base_pos := Vector2.ZERO

func _ready():
	base_pos = position

func _process(_delta: float) -> void:
	var viewport = get_viewport()
	var size = viewport.size
	var mouse_pos = viewport.get_mouse_position()
	position.x = base_pos.x + remap(mouse_pos.x, 0.0, size.x, -1.0, 1.0) * (size.x * 0.05)
	position.y = base_pos.y + remap(mouse_pos.y, 0.0, size.y, -1.0, 1.0) * (size.y * 0.025)
