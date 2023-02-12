extends Node2D


signal fired

const CannonBall := preload("cannon_ball.tscn")

var rng := RandomNumberGenerator.new()

@onready var fire_point := $Barrel/FirePoint
@onready var animation_player := $AnimationPlayer


func _ready() -> void:
	rng.randomize()
	animation_player.seek(rng.randf_range(0, animation_player.get_animation("swing").length))


func _process(_delta: float) -> void:
	var cannonball := CannonBall.instantiate()
	cannonball.direction = global_position.direction_to(transform * Vector2.RIGHT)
	cannonball.position = fire_point.global_position
	add_child(cannonball)
	emit_signal("fired")
