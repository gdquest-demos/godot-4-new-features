extends RigidBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D


func _ready():
	mesh_instance.set("instance_shader_parameters/albedo", Color.from_hsv(randf(), 0.8, 0.5))

