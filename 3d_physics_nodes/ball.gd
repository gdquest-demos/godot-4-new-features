extends RigidBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D


func _ready():
	mesh_instance.set("instance_shader_parameters/albedo", Color.from_hsv(randf_range(0.0, 0.99), 0.5, 0.5))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
