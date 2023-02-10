extends Area


signal clicked()

func _ready() -> void:
	connect("input_event", self, "_on_input_event")


func _on_input_event(_camera, event: InputEvent, _click_position, _click_normal, _shape_idx) -> void:
	
	if not event is InputEventMouseButton:
		return
	
	if not (event as InputEventMouseButton).button_index == BUTTON_LEFT:
		return
	
	if (event as InputEventMouseButton).pressed:
		emit_signal("clicked")
