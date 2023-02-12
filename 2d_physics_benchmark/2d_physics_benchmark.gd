extends Node2D


const CannonBall := preload("cannon_ball.tscn")

@export var init_spawns := 1000

var spawns := 0

@onready var label := $Label
@onready var cannons := $Cannons


func _ready() -> void:
	for cannon in cannons.get_children():
		cannon.connect("fired", increment_spawns)

	for idx in range(init_spawns):
		spawn(20 * index_to_xy(80, idx) + Vector2(180, 400))


func _process(_delta: float) -> void:
	label.text = "FPS %d\nSpawns %d" % [Performance.get_monitor(Performance.TIME_FPS), spawns]


func increment_spawns() -> void:
	spawns += 1


func spawn(location: Vector2) -> void:
	var cannon_ball := CannonBall.instantiate()
	cannon_ball.position = location
	add_child(cannon_ball)
	increment_spawns()


func index_to_xy(width: int, index: int) -> Vector2:
	return Vector2(index % width, index / width)
