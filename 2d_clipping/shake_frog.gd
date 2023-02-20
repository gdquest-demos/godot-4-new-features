extends Control

var angle := 0.0

@onready var circle = $Circle
@onready var frog = $Circle/Frog
@onready var initial_position : Vector2

func _ready():
	connect("resized", _on_resize)
	initial_position = frog.position

func _process(delta: float) -> void:
	angle += 100 * delta
	frog.position = initial_position + Vector2(sin(deg_to_rad(angle)), cos(deg_to_rad(angle))) * circle.size.length() * 0.1

func _on_resize():
	frog.custom_minimum_size = circle.size * 0.8
