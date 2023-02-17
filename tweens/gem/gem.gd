extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal collected

var is_collected := false


func _ready() -> void:
	animate_appearing()
	area_2d.area_entered.connect(
		func (_area: Area2D) -> void:
			if not is_collected:
				collect()
	)


func animate_appearing() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)
	tween.tween_property(self, "rotation", 1, 1.0)
	
	
func collect() -> void:
	const DURATION = 0.8

	is_collected = true
	collected.emit()
	audio_stream_player.play()

	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ZERO, DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation", 7.0, DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)	
	tween.tween_property(self, "position", position + Vector2.UP * 150, DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(audio_stream_player, "volume_db", -60, DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(queue_free)


