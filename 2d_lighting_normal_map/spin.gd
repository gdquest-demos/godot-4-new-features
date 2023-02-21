extends Sprite2D

var angle = 0.0

func _process(delta):
	angle += 1.0 * delta
	position = Vector2(250.0, 0.0).rotated(angle)
