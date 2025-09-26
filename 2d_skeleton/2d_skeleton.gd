extends Node

@onready var goblin = %Goblin
@onready var option_button = %OptionButton

@onready var animation_list = [
	{ "name": "Idle", "callable": goblin.idle },
	{ "name": "Walk", "callable": goblin.run },
]


func _ready() -> void:
	goblin.idle()

	for animation in animation_list:
		option_button.add_item(animation.name)

	option_button.item_selected.connect(_on_item_selected)


func _on_item_selected(item_index: int) -> void:
	animation_list[item_index].callable.call()
