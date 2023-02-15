extends RigidBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@export var gradient : Gradient

func _ready():
	mesh_instance.material_override.set("albedo_color", gradient.sample(randf()))
