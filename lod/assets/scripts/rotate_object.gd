extends Node3D

func _ready():
	var t = create_tween().set_loops()
	t.tween_property(self, "rotation:y", deg_to_rad(360.0), 10.0).from(0.0)
