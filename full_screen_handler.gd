extends Node

var _previous_mouse_mode: Input.MouseMode = Input.mouse_mode


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if OS.has_feature("HTML5"):
		if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else: 
		if event is InputEventKey \
		and  event.is_pressed():
			# Fullscreen
			if (
				event.keycode == KEY_F11 \
				or (
					event.keycode == KEY_ENTER \
					and event.is_alt_pressed()
				)
			):
				get_tree().root.mode = Window.MODE_WINDOWED \
					if get_tree().root.mode == Window.MODE_FULLSCREEN \
					else Window.MODE_FULLSCREEN
			# Decapture Mouse
			elif event.keycode == KEY_ESCAPE \
			and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				_previous_mouse_mode = Input.mouse_mode
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		# Recapture mouse
		elif event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and _previous_mouse_mode == Input.MOUSE_MODE_CAPTURED \
		and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
