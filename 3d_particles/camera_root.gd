extends Node3D


func _ready() -> void:
	var t := create_tween().set_loops(0)
	t.tween_property(self, "rotation_degrees:y", 360.0, 30.0).from(0.0)
