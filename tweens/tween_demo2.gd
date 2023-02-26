extends TextureRect

const DURATION := 0.3
const SMALL := Vector2.ONE * 0.4

@onready var sprite: Sprite2D = %BlueGem


func _ready() -> void:
	sprite.scale = SMALL
	animate()
	

func animate() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.5)
	tween.tween_property(sprite, "rotation", 4, DURATION)
	tween.set_parallel(false)
	tween.tween_property(sprite, "scale", SMALL, DURATION)
	tween.tween_property(sprite, "rotation", 0.0, DURATION)
	
	
	tween.finished.connect(animate)
