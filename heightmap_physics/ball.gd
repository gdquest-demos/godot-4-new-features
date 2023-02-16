extends RigidBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@export var gradient : Gradient

func _ready():
	mesh_instance.material_override.set("albedo_color", gradient.sample(randf()))
	var t = create_tween()
	t.tween_property(mesh_instance, "scale", Vector3.ONE, 0.25).from(Vector3.ONE * 0.1)
