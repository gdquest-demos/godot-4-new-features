extends Node

var _paused = false : set = _set_paused

@onready var scene_holder = $SceneHolder
@onready var main_menu = $MainMenu

func _set_paused(state : bool):
	_paused = state
	get_tree().paused = state
	main_menu.set_is_open(state)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_paused = !_paused
