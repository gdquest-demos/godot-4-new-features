extends Node3D

# For a complete level we'd probably want to use a graph and the AStar pathfinding algorithm.
# But to keep the scene simple, we hard code the path the agent can take.
@onready var path := [$A, $AB, $MovingPlatform/B, $BC, $C]
@onready var beetle: CharacterBody3D = $Beetle

func _ready() -> void:
	beetle.move_targets = path.slice(1)
