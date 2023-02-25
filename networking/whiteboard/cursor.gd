extends CharacterBody2D

signal point_requested(point_position: Vector2, point_color: Color, point_size: float)

enum CONTROL_SCHEME{
	NONE,
	ARROWS,
	CURSOR
}

const SPEED = 300.0
const MIN_BRUSH_SIZE = 5.0

@export var color: Color:
	set(value):
		color = value
		_apply_color()

@export var nickname: String:
	set(value):
		nickname = value
		_apply_nickname()


var control_scheme: CONTROL_SCHEME = CONTROL_SCHEME.NONE
var _is_pressed := false
var _brush_size := 0.0
var _wetness := 10.0
var _mouse_is_over_window := false

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var label: Label = %Label
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %MultiplayerSynchronizer


func _physics_process(delta: float) -> void:
	if not multiplayer_synchronizer.is_multiplayer_authority() \
	or not _mouse_is_over_window:
		return
	var direction := Vector2.ZERO
	match control_scheme:
		CONTROL_SCHEME.ARROWS:
			direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		CONTROL_SCHEME.CURSOR:
			global_position = get_global_mouse_position()
	position += direction * SPEED * delta
	if _is_pressed:
		_brush_size += _wetness * delta
	else:
		_brush_size = MIN_BRUSH_SIZE


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	or event.is_action("ui_accept"):
		if not event.is_pressed():
			_request_point()
			_is_pressed = false
		else:
			_is_pressed = true
	elif _is_pressed and event is InputEventMouseMotion:
		_brush_size = MIN_BRUSH_SIZE
		_request_point()


func _request_point() -> void:
	point_requested.emit(position, color, _brush_size)


func _apply_color() -> void:
	if not is_inside_tree():
		await ready
	label.add_theme_color_override("font_color", color)
	sprite_2d.modulate = color


func _apply_nickname() -> void:
	if not is_inside_tree():
		await ready
	label.text = nickname


func _notification(what: int):
	match what:
		NOTIFICATION_WM_MOUSE_ENTER, \
		NOTIFICATION_APPLICATION_FOCUS_IN:
			_mouse_is_over_window = true
		NOTIFICATION_WM_MOUSE_EXIT, \
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			_mouse_is_over_window = false
