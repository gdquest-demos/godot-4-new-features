extends RigidBody2D


const ALTERNATE_TEXTURE := preload("assets/cannon_ball_red.png")

var direction := Vector2.ZERO
var rng := RandomNumberGenerator.new()

@onready var sprite := $Sprite


func _ready() -> void:
	rng.randomize()
	if rng.randf() > 0.5:
		sprite.texture = ALTERNATE_TEXTURE
	set_as_top_level(true)
	linear_velocity = 1500 * direction
	look_at(direction)
