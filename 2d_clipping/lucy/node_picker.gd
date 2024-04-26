@tool
extends Node

@export var current_index := 0 : set = _set_current_index


func _ready():
	for child in get_children():
		child.hide()
	get_child(current_index).show()


func _set_current_index(index: int):
	get_child(current_index).hide()
	current_index = clamp(index, 0, get_child_count() - 1)
	get_child(current_index).show()
