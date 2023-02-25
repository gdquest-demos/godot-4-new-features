extends Area2D


var _timer := Timer.new()

@export var speed := 350.0

@onready var sprite_2d: Sprite2D = %Sprite2D
@export var color: Color:
	set(value):
		color = value
		_apply_color()


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


func _ready() -> void:
	_is_network_ready = true
	top_level = true
	body_entered.connect(_on_body_entered)
	add_child(_timer)
	_timer.timeout.connect(explode)
	_timer.wait_time = 1
	_timer.start()


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func explode() -> void:
	if not multiplayer.is_server():
		return
	queue_free()


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body != get_parent():
		explode()


func _apply_color() -> void:
	if not _is_network_ready:
		await ready
	sprite_2d.modulate = color
