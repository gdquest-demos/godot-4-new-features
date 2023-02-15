extends Label

func _physics_process(_delta):
	text = "FPS: %.01f" % Engine.get_frames_per_second()
