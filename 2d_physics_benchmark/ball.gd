extends RigidBody2D


const ALTERNATE_TEXTURE := preload("assets/cannon_ball_red.png")

var rng := RandomNumberGenerator.new()

@onready var sprite := $Sprite


func _ready() -> void:
	set_as_top_level(true)
	rng.randomize()
	if rng.randf() > 0.5:
		sprite.texture = ALTERNATE_TEXTURE

	var tween := create_tween()
	scale = Vector2.ONE * rng.randf_range(0, 0.5)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)

	apply_impulse(50 * Vector2.UP.rotated(rng.randf_range(-PI, PI) / 4))
