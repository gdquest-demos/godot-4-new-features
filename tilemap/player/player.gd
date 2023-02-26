extends CharacterBody2D

enum States { MOVE }

@export var speed := 100.0
@export var acceleration := 1000.0
@export var decceleration := 1000.0
@export var aim_deadzone := 0.2


var _direction := Vector2.DOWN
var _input_direction := Vector2.ZERO

@onready var _skin: PlayerSkin = %PlayerSkin


func _ready() -> void:
	_skin.play_animation("Idle")


func _physics_process(delta: float) -> void:
	_input_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).limit_length(1.0)
	
	if _input_direction:
		velocity += _input_direction * acceleration * delta
		velocity = velocity.limit_length(speed * _input_direction.length())
		if _input_direction.length() > aim_deadzone:
			_direction = _input_direction.normalized()
		_skin.play_animation("Move")
		_skin.set_blend_position(_input_direction, _input_direction.length())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, decceleration * delta)
		_skin.play_animation("Idle")
		_skin.set_blend_position(_direction)
	
	move_and_slide()
