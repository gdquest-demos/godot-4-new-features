extends Node



func _ready() -> void:
	chest.opened.connect(_on_chest_opened)



func _on_chest_opened() -> void:
	var contents = chest.contents
	loot_chest(contents)

















#####################################################################


func loot_chest(contents) -> void:
	pass

var chest := Chest.new()

class Chest extends Node:
	var contents
	signal opened
