extends Node

@onready var speech_bubble = $TopUI/SpeechBubble

func _input(_event):
	var sentences = [
		"Nulla a dui nec orci dictum aliquet.", 
		" Suspendisse luctus magna mi, non iaculis neque viverra a.
Integer ut tortor eget neque sagittis pellentesque in sed felis.", 
	"Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Curabitur porta, leo et luctus interdum, nisl sapien
pretium lorem, id sagittis tellus nisi eget felis."
	]
	if Input.is_action_just_pressed("ui_accept"):
		var s = sentences.pick_random()
		speech_bubble.write(s)
