extends Label


func _physics_process(_delta: float) -> void:
	text = "FPS: %.01f" % Engine.get_frames_per_second()
