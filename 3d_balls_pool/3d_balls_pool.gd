extends Node3D

const BALL_SCENE := preload("res://3d_balls_pool/ball.tscn")
const LABEL_TICK := 10

@onready var _camera: Camera3D = $Camera3D
@onready var _fps_label: Label = $FPSLabel
@onready var _active_balls: Label = $ActiveBalls
@onready var _mouse_position: Vector2
@onready var _label_update_frame := 0


func _process(delta):
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or
		Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		var mouse_position = get_viewport().get_mouse_position()
		var direction := _camera.project_ray_normal(mouse_position)
		
		var ball := BALL_SCENE.instantiate()
		add_child(ball)
		ball.global_position = _camera.global_position + (direction * 4.0)
		
		var impulse := randf_range(3.0, 10.0)
		ball.apply_central_impulse(direction * impulse)
	
	_label_update_frame += 1
	if _label_update_frame >= LABEL_TICK:
		_label_update_frame = 0
		_fps_label.text = "FPS: %.01f" % Engine.get_frames_per_second()
		_active_balls.text = "Active balls: %d" % get_tree().get_nodes_in_group("balls").size()
