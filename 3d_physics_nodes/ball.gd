extends RigidBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D


func _ready():
	# Randomize the color of each ball instance
	mesh_instance.set("instance_shader_parameters/albedo", Color.from_hsv(randf_range(0.0, 0.99), 0.5, 0.5))
