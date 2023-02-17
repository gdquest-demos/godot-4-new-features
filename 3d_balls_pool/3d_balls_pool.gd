extends Node3D

const BALL_SCENE := preload("ball.tscn")

@onready var _spawn_position: Marker3D = %SpawnPosition
@onready var _balls_holder: Node3D = %BallsHolder

func _physics_process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):

		var ball := BALL_SCENE.instantiate()
		_balls_holder.add_child(ball)
		ball.global_position = _spawn_position.global_position
		
		var impulse := randf_range(0.0, 3.0)
		ball.apply_central_impulse(Vector3(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized() * impulse)
