extends Node3D


@onready var camera_3d: Camera3D = $Camera3D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var sphere: MeshInstance3D = $Camera3D/Sphere
@onready var beetle: CharacterBody3D = $Beetle


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		ray_cast_3d.target_position = camera_3d.project_ray_normal(get_viewport().get_mouse_position()) * 100.0
		if ray_cast_3d.is_colliding():
			sphere.global_position = ray_cast_3d.get_collision_point()
			beetle.target_global_position = sphere.global_position
