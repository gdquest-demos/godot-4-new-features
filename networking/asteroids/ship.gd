extends CharacterBody2D

var speed := 600.0
var drag_factor := 0.1
@export var local_handling := false

@export var color: Color:
	set(value):
		color = value
		_apply_color()


@export var nickname: String:
	set(value):
		nickname = value
		_apply_nickname()


@onready var label: Label = %Label
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var cannon_marker_2d: Marker2D = %CannonMarker2D
@onready var cool_down_timer: Timer = $CoolDownTimer


func _process(_delta: float) -> void:
	if not local_handling:
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var shoot_request := Input.is_action_pressed("ui_accept")
	move(direction, shoot_request)


func move(direction: Vector2, shoot_request: bool) -> void:
	var desired_velocity := speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	collision_shape_2d.rotation = velocity.angle()
	if shoot_request and cool_down_timer.is_stopped():
		shoot()
		cool_down_timer.start()
	move_and_slide()



func shoot() -> void:
	var laser: Area2D = preload("laser.tscn").instantiate()
	laser.color = color
	add_child(laser)
	laser.global_transform = cannon_marker_2d.global_transform


func _apply_color() -> void:
	if not is_inside_tree():
		await ready
	#label.add_theme_color_override("font_color", color)
	#sprite_2d.modulate = color


func _apply_nickname() -> void:
	if not is_inside_tree():
		await ready
	#label.text = nickname
