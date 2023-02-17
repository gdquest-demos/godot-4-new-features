extends Node3D

const Beetle = preload("beetle_move_to_position.gd")


@onready var camera_3d: Camera3D = %Camera3D
@onready var ray_cast_3d: RayCast3D = %RayCast3D
@onready var sphere: MeshInstance3D = %Sphere
@onready var beetle: Beetle = %Beetle


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		ray_cast_3d.target_position = camera_3d.project_ray_normal(get_viewport().get_mouse_position()) * 100.0
		if ray_cast_3d.is_colliding():
			sphere.global_position = ray_cast_3d.get_collision_point()
			beetle.target_global_position = sphere.global_position
