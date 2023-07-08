extends Node3D

@onready var big_gear = %BigGear
@onready var small_gear = %SmallGear


var base_rotation = 0.0


func _ready():
	var tween := create_tween()
	tween.set_parallel(true)

	tween.set_loops(0)
	tween.tween_method(rotate_gear, base_rotation, base_rotation + 360.0, 2.0)


func rotate_gear(progress):
	base_rotation = progress
	big_gear.rotation_degrees.y = progress
	small_gear.rotation_degrees.y = -progress
	
