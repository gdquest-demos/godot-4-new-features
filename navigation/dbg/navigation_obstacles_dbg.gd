extends Node3D

@onready var character_body: CharacterBody3D = %CharacterBody3D
@onready var camera: Camera3D = %Camera3D
@onready var sphere: MeshInstance3D = %Sphere
@onready var ray_cast: RayCast3D = %RayCast3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		ray_cast.target_position = camera.project_ray_normal(get_viewport().get_mouse_position()) * 100.0
		if ray_cast.is_colliding():
			sphere.global_position = ray_cast.get_collision_point()
			character_body.set_movement_target(sphere.global_position)
