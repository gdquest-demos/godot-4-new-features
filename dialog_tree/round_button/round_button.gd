extends Button

var small_scale = Vector2.ONE * 0.85


func _ready():
	modulate.a = 0.0
	pivot_offset = size / 2.0
	var t = create_tween().set_parallel(true)
	t.tween_property(self, "modulate:a", 1.0, 0.15)

func destroy():
	var t = create_tween().set_parallel(true)
	t.tween_property(self, "scale", small_scale, 0.2).set_trans(Tween.TRANS_BACK)
	t.tween_property(self, "modulate:a", 0.1, 0.15)
	t.chain().tween_callback(queue_free)
