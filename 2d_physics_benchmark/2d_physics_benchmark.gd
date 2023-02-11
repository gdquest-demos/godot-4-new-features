extends Node2D


const RigidBody := preload("rigid_body_2d.tscn")

var rng := RandomNumberGenerator.new()

@onready var fps_label := $FPSLabel


func _ready() -> void:
	for idx in range(4000):
		var rigid_body := RigidBody.instantiate()
		rigid_body.position = Vector2(20, 0) * index_to_xy(1880, idx)
		add_child(rigid_body)


func _process(delta: float) -> void:
	fps_label.text = "FPS %d" % [Performance.get_monitor(Performance.TIME_FPS)]


func index_to_xy(width: int, index: int) -> Vector2:
	return Vector2(index % width, index / width)
