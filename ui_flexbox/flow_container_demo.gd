extends Control

@export var items: Array[Texture] = []

var current_item := 0

@onready var add_item_button := $"%AddItemButton"
@onready var remove_item_button := $"%RemoveItemButton"
@onready var h_flow_container := $"%HFlowContainer"
@onready var vslider := $"%VSlider"


func _ready() -> void:
	add_item_button.connect("pressed", add_item)
	remove_item_button.connect("pressed", remove_item)
	
	vslider.value = theme.get_constant("hseparation", "HFlowContainer")
	vslider.connect("value_changed", set_margins)
	
	for _i in 6:
		add_item()


func add_item() -> void:
	var item = preload("item.tscn").instantiate()
	item.set_deferred("texture", items[current_item])
	current_item = (current_item + 1) % items.size()
	h_flow_container.add_child(item)
	
	# Ensures the animation plays as the container resets the scale otherwise
	await get_tree().process_frame
	var tween :=  create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	item.scale = Vector2.ZERO
	tween.tween_property(item, "scale", Vector2.ONE, 0.3)


func remove_item() -> void:
	if h_flow_container.get_child_count() > 0:
		var last: Node = h_flow_container.get_child(h_flow_container.get_child_count() - 1)
		if last:
			h_flow_container.remove_child(last)


func set_margins(new_value: int) -> void:
	h_flow_container.add_theme_constant_override("v_separation", new_value)
	h_flow_container.add_theme_constant_override("h_separation", new_value)
