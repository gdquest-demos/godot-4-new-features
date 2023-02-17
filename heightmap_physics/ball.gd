extends RigidBody3D

@onready var mesh_instance: MeshInstance3D = %MeshInstance3D
@export var gradient : Gradient

var min_impact_vel := 5.0
var max_impact_vel := 20.0

signal impact(at_position : Vector3 , intensity : float)


func _ready() -> void:
	add_to_group("destroyable")
	mesh_instance.material_override.set("albedo_color", gradient.sample(randf()))
	mesh_instance.material_override.set("emission", gradient.sample(randf()))
	var t := create_tween()
	t.tween_property(mesh_instance, "scale", Vector3.ONE, 0.25).from(Vector3.ONE * 0.1)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.get_contact_count() == 0: return
	var collision_normal := state.get_contact_local_normal(0).normalized()
	var velocity := state.linear_velocity.normalized()
	var direction := velocity.dot(collision_normal)
	if direction > 0.0:
		_request_impact()


func _request_impact() -> void:
	var vel: float = clamp(linear_velocity.length(), 0.0, max_impact_vel)
	if vel < min_impact_vel:
		return
	var value := remap(vel, 0.0, max_impact_vel, 0.0 , 1.0)
	
	var t := create_tween()
	t.tween_property(
		mesh_instance.material_override, 
		"emission_energy_multiplier",
		remap(value, 0.0, 1.0, 0.5, 1.5), 
		remap(value, 0.0, 1.0, 0.1, 0.25)
	)
	t.tween_property(
		mesh_instance.material_override,
		"emission_energy_multiplier", 
		0.0, 
		0.1
	)
	emit_signal("impact", global_position, value)
