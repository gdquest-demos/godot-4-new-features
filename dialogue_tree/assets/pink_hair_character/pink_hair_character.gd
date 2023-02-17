extends Node2D

@onready var bang_start: Bone2D = $Skeleton2D/Body/Neck/Head/BangStart
@onready var bang_end: Bone2D = $Skeleton2D/Body/Neck/Head/BangStart/BangEnd

@onready var back_hair_start: Bone2D = $Skeleton2D/Body/Neck/Head/BackHairStart
@onready var back_hair_end: Bone2D = $Skeleton2D/Body/Neck/Head/BackHairStart/BackHairEnd

@onready var eyes_closed: Sprite2D = $Skeleton2D/Body/Neck/Head/Eyes/EyesClosed
@onready var eyes_open: Sprite2D = $Skeleton2D/Body/Neck/Head/Eyes/EyesOpen

@onready var blink_timer: Timer = $BlinkTimer
@onready var closed_eyes_timer: Timer = $ClosedEyesTimer

@onready var mouth_atlas := {
	"o": $Skeleton2D/Body/Neck/Head/Mouth/MouthO,
	"closed": $Skeleton2D/Body/Neck/Head/Mouth/MouthSmile,
	"wide": $Skeleton2D/Body/Neck/Head/Mouth/MouthWide
}

var current_mouth := "closed"
var babble_count := 0

func _ready() -> void:
	blink_timer.connect("timeout", _on_blink_timer_timeout)

func _on_blink_timer_timeout() -> void:
	eyes_open.hide()
	eyes_closed.show()
	closed_eyes_timer.start()
	await closed_eyes_timer.timeout
	blink_timer.start(randf_range(0.2, 4.0))
	eyes_open.show()
	eyes_closed.hide()


func random_mouth() -> void:
	var possible: Array[String] = ["o", "closed", "wide"]
	possible.erase(current_mouth)
	_change_mouth(possible.pick_random())


func reset_mouth() -> void:
	_change_mouth("closed")


func _change_mouth(mouth_name: String) -> void:
	mouth_atlas[current_mouth].hide()
	mouth_atlas[mouth_name].show()
	current_mouth = mouth_name


func _process(_delta: float) -> void:
	var t := Time.get_ticks_msec() / 150.0
	bang_start.rotation = sin(t) * 0.01
	bang_end.rotation = sin(t + 10.0) * 0.025

	back_hair_start.rotation = sin(t) * 0.025
	back_hair_end.rotation = sin(t + 10.0) * 0.05
