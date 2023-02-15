extends Area2D


var _timer := Timer.new()

@export var speed := 350.0

@onready var sprite_2d: Sprite2D = %Sprite2D
@export var color: Color:
	set(value):
		color = value
		_apply_color()


func _ready() -> void:
	top_level = true
	body_entered.connect(_on_body_entered)
	add_child(_timer)
	_timer.timeout.connect(explode)
	_timer.wait_time = 1
	_timer.start()


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func explode() -> void:
	queue_free()


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body != get_parent():
		explode()


func _apply_color() -> void:
	if not is_inside_tree():
		await ready
	sprite_2d.modulate = color
