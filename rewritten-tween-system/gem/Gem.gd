extends Node2D

@onready var collisionShape := $Area2D/CollisionShape2D
@onready var audioSteamPlayer := $AudioStreamPlayer2D

signal collected

var isCollected := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animate_appearing()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func animate_appearing() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)
	tween.tween_property(self, "rotation", 1, 1.0)
	
	
func collect() -> void:
	isCollected = true
	collected.emit()
	audioSteamPlayer.play()
	
	var d = 0.8 #duration
	var newPos = position + Vector2.UP * 150
	var newRot = 7
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ZERO, d).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation", newRot, d).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)	
	tween.tween_property(self, "position", newPos, d).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(audioSteamPlayer, "volume_db", -60, d).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(queue_free)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if !isCollected:
		collect()
		
	
