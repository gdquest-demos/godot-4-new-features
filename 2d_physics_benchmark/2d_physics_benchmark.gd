extends Node2D


const Ball := preload("ball.tscn")

@export var init_spawns := 1000
@export var grid_spawns_offset := Vector2(180, 980)

var _rng := RandomNumberGenerator.new()
var _spawns_count := 0

@onready var label := $Label


func _ready() -> void:
	_rng.randomize()
	for idx in init_spawns:
		var ball_position := 30 * _index_to_xy(50, idx).reflect(Vector2.RIGHT)
		var offset := grid_spawns_offset + Vector2(_rng.randf_range(-5, 5), _rng.randf_range(-5, 5))
		_spawn_ball(ball_position + offset)


func _process(_delta: float) -> void:
	_spawn_ball(Vector2(960, 100))
	label.text = "FPS %d\nSpawns %d" % [Performance.get_monitor(Performance.TIME_FPS), _spawns_count]


func _spawn_ball(location: Vector2) -> void:
	var ball := Ball.instantiate()
	ball.position = location
	add_child(ball)
	_spawns_count += 1


func _index_to_xy(width: int, index: int) -> Vector2:
	@warning_ignore("integer_division")
	return Vector2(index % width, index / width)
