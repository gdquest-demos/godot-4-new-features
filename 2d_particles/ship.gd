extends Node2D


@export_node_path("Node2D") var target_path

@onready var shooting := %ShootingGPUParticles2D
@onready var target := get_node(target_path)


func _process(delta: float) -> void:
	var direction: Vector2 = (target.global_position - global_position).normalized()
	shooting.process_material.direction = Vector3(direction.x, direction.y, 0)
