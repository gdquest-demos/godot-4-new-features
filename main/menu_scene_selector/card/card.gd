extends VBoxContainer

@onready var thumbnail = %Thumbnail
@onready var title = %Title

var active = false : set = _set_active
var focused = false : set = _set_focus

var default_zoom = 1.0
var zoomed_in = 1.15

signal pressed

func _ready():
	connect("resized", _set_pivot)
	connect("mouse_entered", _set_focus.bind(true))
	connect("mouse_exited", _set_focus.bind(false))
	connect("focus_entered", _set_focus.bind(true))
	connect("focus_exited", _set_focus.bind(false))
	_set_pivot()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pressed.emit()
	if event.is_action_pressed("ui_accept"):
		pressed.emit()


func _set_active(state : bool):
	active = state
	if state:
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


func _set_focus(state : bool):
	if active: return
	focused = state
	if state:
		thumbnail.current_zoom = zoomed_in
		title.modulate.a = 1.0
	else:
		thumbnail.current_zoom = default_zoom
		title.modulate.a = 0.75


func set_title(value : String):
	title.text = value

func set_thumbnail(value : Texture2D):
	thumbnail.texture = value
	thumbnail.set_texture_ratio()

func _set_pivot():
	pivot_offset = size / 2.0
