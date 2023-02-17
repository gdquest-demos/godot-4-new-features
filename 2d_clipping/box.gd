extends Sprite2D

var angle := 0.0

@onready var _face_sprite: Sprite2D = $Mask/Sprite2D
@onready var _initial_position := _face_sprite.position


func _process(delta: float) -> void:
	angle += 100 * delta
	_face_sprite.position = _initial_position + Vector2(sin(deg_to_rad(angle)), cos(deg_to_rad(angle))) * 10
