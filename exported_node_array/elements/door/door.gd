extends Node3D

signal state_changed(is_open: bool)


@export var switches: Array[Button3D] = []


@onready var door_bottom = %DoorBottom
@onready var door_top = %DoorTop


var _is_open := false:
	set(value):
		if _is_open == value: return
		_is_open = value
		toggle_door_open()


func _ready():
	for switch in switches:
		switch.connect("state_changed", func check_switches(_switch_state):
			_is_open = switches.all(func(switch):
				return switch.state
		))


func toggle_door_open():
	var top_value = 1.0 if _is_open else 0.0
	var bottom_value = -1.0 if _is_open else 0.0
	
	var tween = create_tween().set_parallel(true)
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK if _is_open else Tween.TRANS_BOUNCE)
		
	tween.tween_property(door_top, "position:y", top_value, 1.0)
	tween.tween_property(door_bottom, "position:y", bottom_value, 1.0)
