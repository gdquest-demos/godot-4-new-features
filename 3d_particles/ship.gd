extends Node3D


@export_node_path("Node3D") var target_path

@onready var shooting := %ShootingGPUParticles2D
@onready var target := get_node(target_path)


func _process(delta: float) -> void:
	shooting.process_material.direction = (target.global_position - global_position).normalized()
