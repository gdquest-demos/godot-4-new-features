@tool
## A node that can hold an item
class_name InventoryItemNode extends PanelContainer

var label := Label.new()
var texture_rect := TextureRect.new()


@export var item: InventoryItem:
	set(value):
		item = value
		_update()
		if item != null and not item.changed.is_connected(_update):
			item.changed.connect(_update)


func _init() -> void:
	var margin_container := MarginContainer.new()
	var margin_value = 10
	margin_container.add_theme_constant_override("margin_top", margin_value)
	margin_container.add_theme_constant_override("margin_left", margin_value)
	margin_container.add_theme_constant_override("margin_bottom", margin_value)
	margin_container.add_theme_constant_override("margin_right", margin_value)
	add_child(margin_container)
	
	var container := VBoxContainer.new()
	container.add_theme_constant_override("separation", 5)
	
	margin_container.add_child(container)
	
	texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texture_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	container.add_child(texture_rect)
	
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(label)


func _ready() -> void:
	_update()


func _update() -> void:
	if item != null:
		label.text = item.full_title
		texture_rect.texture = item.texture
	else:
		label.text = "no item"
		texture_rect.texture = null
