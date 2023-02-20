extends Control

var focused = false : set = _set_focus
var disabled = false : set = _set_disabled


var current_alpha = 0.0 : set = _set_current_alpha
var current_scale = 0.0 : set = _set_current_scale

var default_alpha = 0.8
var disabled_alpha = 0.25

@onready var arrow = $Arrow

signal pressed
	
func _gui_input(event):
	if !(event is InputEventMouseButton): return
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		press()


func _ready():
	connect("resized", _on_resize)
	connect("mouse_entered", _set_focus.bind(true))
	connect("mouse_exited", _set_focus.bind(false))
	connect("focus_entered", emit_signal.bind("pressed"))
	arrow.modulate.a = default_alpha


func _set_focus(state : bool):
	focused = state
	
	if disabled: return

	if focused:
		current_scale = 1.1
		current_alpha = 1.0
	else:
		current_scale = 1.0
		current_alpha = default_alpha


func _set_disabled(state : bool):
	disabled = state
	
	if disabled:
		current_scale = 1.0
		current_alpha = disabled_alpha
		focus_mode = Control.FOCUS_NONE
	else:
		current_alpha = default_alpha
		focus_mode = Control.FOCUS_ALL


func _set_current_alpha(value : float):
	var t = create_tween()
	t.tween_property(arrow, "modulate:a", value, 0.15)


func _set_current_scale(value : float):
	var t = create_tween()
	t.tween_property(arrow, "scale", Vector2.ONE * value, 0.15)


func _on_resize():
	arrow.pivot_offset = arrow.size / 2.0


func press():
	pressed.emit()
