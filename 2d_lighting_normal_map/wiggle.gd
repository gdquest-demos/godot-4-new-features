extends Sprite2D

func _ready():
	var t = create_tween().set_loops(0).set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "rotation_degrees", -8, 2.0)
	t.tween_property(self, "rotation_degrees", 8, 2.0)
