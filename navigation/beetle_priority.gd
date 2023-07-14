extends CharacterBody3D

const SPEED := 3.0

var patrol_points: Array = []
var patrol_index := 0

@onready var skin: Node3D = %BeetlebotSkin
@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	navigation_agent.velocity_computed.connect(_on_navigation_agent_velocity_computed)
	navigation_agent.navigation_finished.connect(_on_navigation_agent_navigation_finished)
	navigation_agent.radius = 0.5
	skin.walk()


func _physics_process(_delta : float) -> void:
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position := navigation_agent.get_next_path_position()
	var direction := (next_path_position - global_position).normalized()
	var new_velocity := direction * SPEED
	navigation_agent.set_velocity(new_velocity)


func _on_navigation_agent_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	var current_model_transform := skin.global_transform
	skin.look_at(global_position + velocity, Vector3.UP, true)
	skin.global_transform = current_model_transform.interpolate_with(skin.global_transform, 10.0 * get_physics_process_delta_time())
	move_and_slide()


func _on_navigation_agent_navigation_finished():
	navigation_agent.set_target_position(patrol_points[patrol_index])
	patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())


func set_patrol_points(value: Array) -> void:
	patrol_points = value
	if patrol_points.size() > 0:
		navigation_agent.set_target_position(patrol_points[patrol_index])
