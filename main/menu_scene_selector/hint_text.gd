@tool
extends CanvasLayer

enum POSITION{
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_RIGHT,
	BOTTOM_LEFT,
	FOLLOWS_MOUSE
}

@export var positioning: POSITION = POSITION.TOP_LEFT:
	set(value):
		positioning = value
		if not is_inside_tree():
			await ready
		match positioning:
			POSITION.TOP_RIGHT:
				panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
			POSITION.BOTTOM_RIGHT:
				panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
			POSITION.BOTTOM_LEFT:
				panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
			_:
				panel.set_anchors_preset(Control.PRESET_TOP_LEFT)

@export var disabled := false


@export var parent: Control:
	set(value):
		parent = value
		if Engine.is_editor_hint():
			return
		if not parent.is_inside_tree():
			await parent.ready
		if parent != null:
			panel.hide()
		parent.mouse_entered.connect(popup)
		parent.mouse_exited.connect(popout)
		parent.visibility_changed.connect(
			func on_visibility_changed():
				visible = parent.visible
		)


@export var title := "":
	set(value):
		title = value
		if not is_inside_tree():
			await ready
		title_label.text = title
		title_label.visible = title != ""


@export_multiline var text := "":
	set(value):
		text = value
		if not is_inside_tree():
			await ready
		rich_text_label.text = text


@export var logo_visible := false:
	set(value):
		logo_visible = value
		if not is_inside_tree():
			await ready
		logo_texture_rect.visible = logo_visible


@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var panel: PanelContainer = %Panel
@onready var title_label: Label = %TitleLabel
@onready var logo_texture_rect: TextureRect = %LogoTextureRect

var _is_over_parent := false


func popup() -> void:
	if disabled == true:
		return
	_is_over_parent = true
	panel.show()
	var tween := create_tween()
	tween\
		.tween_property(panel, "modulate:a", 1.0, 0.6)\
		.from(0.0)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)


func popout() -> void:
	if disabled == true:
		return
	_is_over_parent = false
	var tween := create_tween()
	tween\
		.tween_property(panel, "modulate:a", 0.0, 0.2)\
		.from(1.0)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_CUBIC)
	tween.finished.connect(panel.hide)


func _ready() -> void:
	title_label.visible = title != ""
	if Engine.is_editor_hint():
		set_physics_process(false)


func _physics_process(_delta: float) -> void:
	if positioning != POSITION.FOLLOWS_MOUSE \
	or visible == false \
	or panel.visible == false \
	or (parent != null and _is_over_parent == false):
		return
	panel.global_position = panel.get_global_mouse_position()
