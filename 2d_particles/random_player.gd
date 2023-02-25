extends AudioStreamPlayer

@export var sounds : Array[AudioStream] = []

func play_random():
	stream = sounds.pick_random()
	play()
