extends Node2D

@onready var bang_start = $Skeleton2D/Body/Neck/Head/BangStart
@onready var bang_end = $Skeleton2D/Body/Neck/Head/BangStart/BangEnd

@onready var back_hair_start = $Skeleton2D/Body/Neck/Head/BackHairStart
@onready var back_hair_end = $Skeleton2D/Body/Neck/Head/BackHairStart/BackHairEnd

@onready var eyes_closed = $Skeleton2D/Body/Neck/Head/Eyes/EyesClosed
@onready var eyes_open = $Skeleton2D/Body/Neck/Head/Eyes/EyesOpen

@onready var blink_timer = $BlinkTimer
@onready var closed_eyes_timer = $ClosedEyesTimer

@onready var mouth_atlas = {
	"o": $Skeleton2D/Body/Neck/Head/Mouth/MouthO,
	"closed": $Skeleton2D/Body/Neck/Head/Mouth/MouthSmile,
	"wide": $Skeleton2D/Body/Neck/Head/Mouth/MouthWide
}

var current_mouth = "closed"
var babble_count = 0

func _ready():
	blink_timer.connect("timeout", _on_blink_timer_timeout)

func _on_blink_timer_timeout():
	eyes_open.hide()
	eyes_closed.show()
	closed_eyes_timer.start()
	await closed_eyes_timer.timeout
	blink_timer.start(randf_range(0.2, 4.0))
	eyes_open.show()
	eyes_closed.hide()

func _random_mouth():
	var possible = ["o", "closed", "wide"]
	possible.erase(current_mouth)
	_change_mouth(possible.pick_random())

func _reset_mouth():
	_change_mouth("closed")
	
func _change_mouth(mouth_name):
	mouth_atlas[current_mouth].hide()
	mouth_atlas[mouth_name].show()
	current_mouth = mouth_name
	
func _process(_delta):
	var t = Time.get_ticks_msec() / 150.0
	bang_start.rotation = sin(t) * 0.01
	bang_end.rotation = sin(t + 10.0) * 0.025

	back_hair_start.rotation = sin(t) * 0.025
	back_hair_end.rotation = sin(t + 10.0) * 0.05
