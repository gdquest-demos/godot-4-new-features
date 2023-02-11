extends Node2D


const RigidBody := preload("rigid_body_2d.tscn")
const SPAWNS_INIT := 4000

var spawns := 0

@onready var label := $Label
@onready var marker := $Marker2D


func _ready() -> void:
	for idx in range(SPAWNS_INIT):
		spawn(Vector2(20, 0) * index_to_xy(1880, idx))


func _process(delta: float) -> void:
	label.text = "FPS %d\nSpawns %d" % [Performance.get_monitor(Performance.TIME_FPS), spawns]
	spawn(marker.position)


func spawn(location: Vector2) -> void:
	var rigid_body := RigidBody.instantiate()
	rigid_body.position = location
	add_child(rigid_body)
	spawns += 1

func index_to_xy(width: int, index: int) -> Vector2:
	return Vector2(index % width, index / width)
