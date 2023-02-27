@tool
extends CanvasLayer

@export var disabled := false

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


@export var global_position := Vector2.ZERO:
	set(value):
		global_position = value
		if not is_inside_tree():
			await ready
		panel.global_position = global_position


@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var panel: PanelContainer = %Panel
@onready var title_label: Label = %TitleLabel
@onready var logo_texture_rect: TextureRect = %LogoTextureRect

var _is_active := false

func popup(immediate := false) -> void:
	if not is_inside_tree():
		await ready
	panel.show()
	if immediate == true:
		panel.modulate.a = 1
	_is_active = true
	var tween := create_tween()
	tween\
		.tween_property(panel, "modulate:a", 1.0, 0.6)\
		.from(0.0)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)


func popout(immediate := false) -> void:
	if not is_inside_tree():
		await ready
	if immediate == true:
		panel.hide()
		return
	if _is_active == false:
		return
	_is_active = false
	var tween := create_tween()
	tween\
		.tween_property(panel, "modulate:a", 0.0, 0.2)\
		.from(1.0)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_CUBIC)
	tween.finished.connect(panel.hide)


func set_anchors_and_offsets_preset(
		preset: Control.LayoutPreset, 
		resize_mode: Control.LayoutPresetMode = Control.PRESET_MODE_MINSIZE,
		margin := 0
	) -> void:
		if not is_inside_tree():
			await ready
		panel.set_anchors_and_offsets_preset(preset, resize_mode, margin)


func _ready() -> void:
	title_label.visible = title != ""
