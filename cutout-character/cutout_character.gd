extends Node2D

@onready var _no_canvas_node: Node2D = $NoCanvasGroup
@onready var _canvas_node: CanvasGroup = $CanvasGroup


func _tween_transparency() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(_no_canvas_node, "modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_property(_canvas_node, "self_modulate", Color(1, 1, 1, 0), 1.0)
