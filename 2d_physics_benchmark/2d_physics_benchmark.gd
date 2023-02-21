extends Node2D


const Ball := preload("ball.tscn")

@export var count_limit : int = 4000

@onready var spawn : Node2D = %Spawn

@export var init_spawns := 1000
@export var grid_spawns_offset := Vector2(180, 980)

var _rng := RandomNumberGenerator.new()
var _spawns_count := 0

@onready var label := %PerfLabel

func _ready() -> void:
	_rng.randomize()
	for idx in init_spawns:
		var ball_position := 30 * _index_to_xy(50, idx).reflect(Vector2.RIGHT)
		var offset := grid_spawns_offset + Vector2(_rng.randf_range(-5, 5), _rng.randf_range(-5, 5))
		_spawn_ball(ball_position + offset)


func _process(_delta: float) -> void:
	_spawn_ball(spawn.global_position, Vector2(0.0, 800.0).rotated(spawn.rotation))
	label.text = "FPS %d\nSpawns %d" % [Performance.get_monitor(Performance.TIME_FPS), _spawns_count]


func _spawn_ball(location: Vector2, initial_velocity : Vector2 = Vector2.ZERO ) -> void:
	var ball := Ball.instantiate()
	ball.position = location
	ball.linear_velocity = initial_velocity
	add_child(ball)
	_spawns_count += 1
	if _spawns_count >= count_limit: set_process(false)

func _index_to_xy(width: int, index: int) -> Vector2:
	@warning_ignore("integer_division")
	return Vector2(index % width, index / width)
