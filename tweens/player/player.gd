extends Sprite2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var particles: GPUParticles2D = $GPUParticles2D

var tween_sound: Tween
var tween_motion: Tween


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		move_to_mouse(event.position)


func move_to_mouse(mouse_position:Vector2) -> void:
	const VOLUME_MIN = -60
	const VOLUME_MAX = -20

	audio_stream_player.volume_db = VOLUME_MIN
	audio_stream_player.play(1)
	
	if tween_sound:
		tween_sound.kill()
	tween_sound = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween_sound.tween_property(audio_stream_player, "volume_db", VOLUME_MAX, 0.5).set_ease(Tween.EASE_OUT)
	tween_sound.tween_property(audio_stream_player, "volume_db", VOLUME_MIN, 0.5).set_ease(Tween.EASE_IN)
	
	if tween_motion:
		tween_motion.kill()
	var target_rotation := global_position.direction_to(mouse_position).angle() + PI / 2.0
	tween_motion = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween_motion.tween_property(self, "global_position", mouse_position, 1.0)
	tween_motion.parallel().tween_property(self, "rotation", target_rotation, 0.25)
	
	var tween_color := create_tween().set_trans(Tween.TRANS_CUBIC)
	tween_color.tween_property(particles, "modulate", Color.RED, 0.5).set_ease(Tween.EASE_IN)
	tween_color.tween_property(particles, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN)
