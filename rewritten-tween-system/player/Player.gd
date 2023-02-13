extends Sprite2D

@onready var audioSteamPlayer := $AudioStreamPlayer2D
@onready var particlesMiddle := $"GPUParticles2D"

var tweenSound
var tweenMotion

func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		move_to_mouse(event.position)


func move_to_mouse(mouse_position:Vector2) -> void:
	
	audioSteamPlayer.play(1)
	var lowVol = -60
	var highVol = -20	
	audioSteamPlayer.volume_db = lowVol
	
	if tweenSound: tweenSound.kill()
	tweenSound = create_tween().set_trans(Tween.TRANS_CUBIC)
	tweenSound.tween_property(audioSteamPlayer, "volume_db", highVol, 0.5).set_ease(Tween.EASE_OUT)
	tweenSound.tween_property(audioSteamPlayer, "volume_db", lowVol, 0.5).set_ease(Tween.EASE_IN)
	
	if tweenMotion: tweenMotion.kill()
	var target_rotation := global_position.direction_to(mouse_position).angle() + PI / 2.0
	tweenMotion = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tweenMotion.tween_property(self, "global_position", mouse_position, 1.0)
	tweenMotion.parallel().tween_property(self, "rotation", target_rotation, 0.25)
	
	var tweenColor = create_tween().set_trans(Tween.TRANS_CUBIC)
	tweenColor.tween_property(particlesMiddle, "modulate", Color.RED, 0.5).set_ease(Tween.EASE_IN)
	tweenColor.tween_property(particlesMiddle, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN)
