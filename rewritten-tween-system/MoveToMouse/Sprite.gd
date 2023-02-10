extends Sprite


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		move_to_mouse()


func move_to_mouse() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", get_global_mouse_position(), 1.0)

	var target_rotation := global_position.direction_to(get_global_mouse_position()).angle() + PI / 2.0
	tween.parallel().tween_property(self, "rotation", target_rotation, 0.5)
