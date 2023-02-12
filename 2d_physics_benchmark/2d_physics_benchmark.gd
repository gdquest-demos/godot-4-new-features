extends Node2D


const Ball := preload("ball.tscn")

@export var init_spawns := 1000
@export var grid_spawns_offset := Vector2(180, 980)

var rng := RandomNumberGenerator.new()
var spawns := 0

@onready var label := $Label


func _ready() -> void:
	rng.randomize()
	grid_spawn()


func _process(_delta: float) -> void:
	spawn(Vector2(960, 100))
	label.text = "FPS %d\nSpawns %d" % [Performance.get_monitor(Performance.TIME_FPS), spawns]


func grid_spawn() -> void:
	for idx in range(init_spawns):
		var offset := grid_spawns_offset + Vector2(rng.randf_range(-5, 5), rng.randf_range(-5, 5))
		spawn(30 * index_to_xy(50, idx).reflect(Vector2.RIGHT) + offset)


func spawn(location: Vector2) -> void:
	var ball := Ball.instantiate()
	ball.position = location
	add_child(ball)
	spawns += 1


func index_to_xy(width: int, index: int) -> Vector2:
	return Vector2(index % width, index / width)
