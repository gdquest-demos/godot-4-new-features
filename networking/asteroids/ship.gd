extends CharacterBody2D

var speed := 600.0
var drag_factor := 0.1

@export var is_multiplayer := false

@export var angle := 0.0:
	set(value):
		angle = value
		_apply_angle()

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


## When a node is synced, the `ready` methods aren't called, and so all the
## `@onready` properties are `null`. To work around this, we have three solutions:
## 1. Set the properties that need sub-nodes to `sync` and uncheck `spawn` in the 
##    MultiplayerSynchronizer node. This does not provoke initial setter calls 
##    without `@onready` props; but it means we waste bandwidth by synchronizing
##    properties that only need to be set once.
## 2. Not use setters, and set the properties inside `_ready()`. This is proper,
##    but does break a bit if the general API uses setters (or, for example, if 
##    you wanted to use `@tool` and preview changes to exported properties in the
##    editor.
## 3. Set a boolean in `_ready`, which will only become true once `_ready` is
##    actually called.
## Note that locally, this boolean is also set to true, so this variable could be
## called `is_network_ready_or_is_local`, but that's a mouthful.
var _is_network_ready := false


func _ready():
	_is_network_ready = true


func _process(_delta: float) -> void:
	if is_multiplayer == true:
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	move(direction)
	if Input.is_action_pressed("ui_accept"):
		shoot()


func move(direction: Vector2) -> void:
	var desired_velocity := speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	angle = velocity.angle()
	move_and_slide()


func shoot() -> void:
	if not cool_down_timer.is_stopped():
		return
	cool_down_timer.start()
	var laser: Area2D = preload("laser.tscn").instantiate()
	laser.color = color
	laser.global_transform = cannon_marker_2d.global_transform
	add_child(laser, true)


func _apply_color() -> void:
	if not _is_network_ready:
		await ready
	label.add_theme_color_override("font_color", color)
	sprite_2d.modulate = color


func _apply_nickname() -> void:
	if not _is_network_ready:
		await ready
	label.text = nickname


func _apply_angle() -> void:
	if not _is_network_ready:
		await ready
	collision_shape_2d.rotation = angle
