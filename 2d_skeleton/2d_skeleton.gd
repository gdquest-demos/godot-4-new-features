extends Node

@onready var goblin = %Goblin
@onready var option_button = %OptionButton

@onready var animation_list = [
	{"name": "Idle", "callable": Callable(goblin, "idle")},
	{"name": "Walk", "callable": Callable(goblin, "run")},
]

func _ready():
	goblin.idle()
	
	for animation in animation_list:
		option_button.add_item(animation.name)
	
	option_button.connect("item_selected", _on_item_selected)

func _on_item_selected(item_index : int):
	animation_list[item_index].callable.call()
