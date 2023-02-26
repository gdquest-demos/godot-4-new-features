extends CharacterBody2D

@export var speed := 50.0

var _direction := Vector2.ZERO

var _player: Node2D

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _area: Area2D = $Area2D


func _ready() -> void:
	_area.connect("body_entered", func (body: Node2D) -> void:
		_player = body
		_animated_sprite.play("move")
		set_physics_process(true)
	)
	_area.connect("body_exited", func (_body: Node2D) -> void:
		_animated_sprite.play("idle")
		set_physics_process(false)
	)
	
	set_physics_process(false)


func _physics_process(_delta: float) -> void:
	_direction = _player.global_position.direction_to(global_position)
	_animated_sprite.flip_h = _direction.x < 0
	velocity = speed * _direction
	move_and_slide()
