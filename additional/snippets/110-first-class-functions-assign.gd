extends Node2D


var disappear_function: Callable = fade_and_hide


func _ready():
	# Wait for 0.5 seconds
	await get_tree().create_timer(0.5).timeout
	disappear_function.call()


func scale_down_and_hide():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 1.0)
	await tween.finished
	hide()


func fade_and_hide():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	await tween.finished
	hide()
