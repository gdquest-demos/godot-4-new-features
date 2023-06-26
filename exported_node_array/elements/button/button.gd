class_name Button3D
extends Node3D

signal state_changed(state: bool)

var state := false:
	set(value):
		if state == value:
			return
		state = value
		state_changed.emit(value)

@export var off_color : Color 
@export var on_color : Color 

@onready var button = %Button
@onready var area_3d = %Area3D


func _ready():
	connect("state_changed", check_state)
	area_3d.connect("input_event",
		func(_camera, event, _pos, _normal, _shape_idx):
			if !(event is InputEventMouseButton):
				return
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				state = !state
	)


func check_state(_new_state: bool):
	var color = on_color if state else off_color
	var depth = -0.1 if state else 0.0
	var tween = create_tween().set_parallel(true)
	tween.tween_property(button, "position:y", depth, 0.2)
	tween.tween_property(button.material_override, "albedo_color", color, 0.2)
