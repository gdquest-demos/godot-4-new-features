extends RigidBody2D


const ALTERNATE_TEXTURE := preload("assets/cannon_ball_red.png")

var rng := RandomNumberGenerator.new()

@onready var sprite := $Sprite
@export var gradient : Gradient

func _ready() -> void:
	rng.randomize()

	var tween := create_tween()
	
	var base_scale = sprite.scale
	tween.tween_property(sprite, "scale", base_scale, 0.4).from(Vector2.ZERO)
	
	sprite.modulate = gradient.sample(randf())
	
	apply_impulse(50 * Vector2.UP.rotated(rng.randf_range(-PI, PI) / 4))
