extends Node3D

const BALL_SCENE = preload("res://heightmap_physics/ball.tscn")
@export var _spawn_position : Marker3D
@export var _random_sound_player : Node


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("jump"):
		var ball := BALL_SCENE.instantiate()
		add_child(ball)
		ball.connect("impact", _random_sound_player.play_random_at)
		ball.global_position = _spawn_position.global_position
		
		var impulse := randf_range(0.0, 3.0)
		ball.apply_central_impulse(Vector3(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized() * impulse)
		
