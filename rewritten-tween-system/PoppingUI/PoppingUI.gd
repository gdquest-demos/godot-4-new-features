extends Control

onready var gems := [$Slot1/Gem, $Slot2/Gem, $Slot3/Gem]
onready var button := $Button


func _ready() -> void:
	button.connect("pressed", self, "animate_rectangles_appearing")
	for gem in gems:
		gem.rect_scale = Vector2.ZERO


func animate_rectangles_appearing() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	for gem in gems:
		gem.rect_scale = Vector2.ZERO
		gem.rect_rotation = -30.0

		tween.tween_property(gem, "rect_scale", Vector2.ONE, 0.5)
		tween.parallel().tween_property(gem, "rect_rotation", 0.0, 1.0)
