extends Marker2D

func _ready():
	var t = create_tween().set_loops(0).set_trans(Tween.TRANS_SINE).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	t.tween_property(self, "rotation_degrees", 90, 2.0)
	t.tween_property(self, "rotation_degrees", -90, 2.0)
