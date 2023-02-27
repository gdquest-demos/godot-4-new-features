extends VBoxContainer

const HintText = preload("res://main/menu_scene_selector/hint_text.gd")

@onready var thumbnail = %Thumbnail
@onready var title = %Title
@onready var hint_text: HintText = %HintText

var active = false : set = _set_active
var focused = false : set = _set_focus

var default_zoom = 1.0
var zoomed_in = 1.15

signal pressed

func _ready() -> void:
	resized.connect(_set_pivot)
	mouse_entered.connect(_set_mouse_over.bind(true))
	mouse_exited.connect(_set_mouse_over.bind(false))
	focus_entered.connect(_set_focus.bind(true))
	focus_exited.connect(_set_focus.bind(false))
	_set_pivot()
	hint_text.popout(true)
	await get_tree().physics_frame
	await get_tree().physics_frame
	hint_text.global_position = global_position + size / 2


func _gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pressed.emit()
	if event.is_action_pressed("ui_accept"):
		pressed.emit()
	elif event is InputEventMouseMotion:
		hint_text.global_position = event.global_position


func _set_active(state : bool) -> void:
	active = state
	if state:
		hint_text.popout()
		var t = create_tween()
		t.tween_property(self, "scale", Vector2.ONE * 1.025, 0.1)
		t.tween_property(self, "scale", Vector2.ONE, 0.1)
		thumbnail.current_zoom = zoomed_in
		thumbnail.current_gradient_opacity = 1.0
		title.modulate.a = 1.0
	else:
		thumbnail.current_zoom = default_zoom
		thumbnail.current_gradient_opacity = 0.0
		title.modulate.a = 0.75


func _set_mouse_over(state : bool) -> void:
	if state:
		hint_text.popup()
	else:
		hint_text.popout()
	if active:
		return
	_set_focus(state)


func _set_focus(state : bool) -> void:
	if active:
		return
	focused = state
	if state:
		thumbnail.current_zoom = zoomed_in
		title.modulate.a = 1.0
	else:
		thumbnail.current_zoom = default_zoom
		title.modulate.a = 0.75


func set_title(value : String) -> void:
	title.text = value


func set_thumbnail(value : Texture2D) -> void:
	thumbnail.texture = value
	thumbnail.set_texture_ratio()


func set_description(value: String) -> void:
	hint_text.text = value


func _set_pivot() -> void:
	pivot_offset = size / 2.0
