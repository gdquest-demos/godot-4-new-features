@tool
extends PanelContainer

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


@export var general_instructions_visible := false:
	set(value):
		general_instructions_visible = value
		if not is_inside_tree():
			await ready
		instructions_rich_text_label.visible = general_instructions_visible


@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var title_label: Label = %TitleLabel
@onready var logo_texture_rect: TextureRect = %LogoTextureRect
@onready var instructions_rich_text_label: RichTextLabel = %InstructionsRichTextLabel


func popup(immediate := false) -> void:
	if not is_inside_tree():
		await ready
	
	# Force container to be its smallest size possibles
	size = Vector2.ZERO
	
	show()
	if immediate == true:
		modulate.a = 1
		return
	var tween := create_tween()
	tween\
		.tween_property(self, "modulate:a", 1.0, 0.6)\
		.from(0.0)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)


func popout(immediate := false) -> void:
	if not is_inside_tree():
		await ready
	if immediate == true:
		modulate.a = 0
		return
	var tween := create_tween()
	tween\
		.tween_property(self, "modulate:a", 0.0, 0.2)\
		.from(1.0)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_CUBIC)
	tween.finished.connect(hide)

func _ready() -> void:
	title_label.visible = title != ""
	logo_texture_rect.visible = logo_visible
	instructions_rich_text_label.visible = general_instructions_visible
