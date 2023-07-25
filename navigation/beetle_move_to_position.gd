extends CharacterBody3D

const SPEED := 3.0

var target_global_position := Vector3.INF:
	set(new_target_global_position):
		target_global_position = new_target_global_position
		var is_near_target := global_position.distance_to(target_global_position) < _navigation_agent.target_desired_distance
		var has_new_target := not is_near_target and target_global_position != Vector3.INF
		set_physics_process(has_new_target)
		set_avoidance_enabled(has_new_target)
		if has_new_target:
			if not _navigation_agent.velocity_computed.is_connected(move):
				_navigation_agent.velocity_computed.connect(move)
			_navigation_agent.target_position = target_global_position
			_beetle_skin.walk()

@onready var _beetle_skin: Node3D = %BeetlebotSkin
@onready var _navigation_agent: NavigationAgent3D = %NavigationAgent3D


func _ready() -> void:
	_navigation_agent.navigation_finished.connect(stop)
	_navigation_agent.max_speed = SPEED
	_beetle_skin.idle()
	set_physics_process(false)


func set_avoidance_enabled(enabled: bool) -> void:
	_navigation_agent.avoidance_enabled = enabled
	if not enabled and _navigation_agent.velocity_computed.is_connected(move):
		_navigation_agent.velocity_computed.disconnect(move)


func set_avoidance_radius(radius: float) -> void:
	_navigation_agent.radius = radius


func _physics_process(delta: float) -> void:
	# Wait for the next location to be accessible, for example, a moving platform.
	var next_location := _navigation_agent.get_next_path_position()
	var direction := (next_location - global_position).normalized()

	var new_velocity := direction * SPEED
	if _navigation_agent.avoidance_enabled:
		_navigation_agent.velocity = new_velocity
	else:
		move(new_velocity)


func move(safe_velocity: Vector3) -> void:
	velocity = safe_velocity

	# Make the model turn towards where the agent is moving.
	var current_model_transform := _beetle_skin.global_transform
	_beetle_skin.look_at(global_position + velocity, Vector3.UP, true)
	_beetle_skin.global_transform = current_model_transform.interpolate_with(_beetle_skin.global_transform, 10.0 * get_physics_process_delta_time())

	move_and_slide()


func stop() -> void:
	_beetle_skin.idle()
	set_physics_process(false)
	set_avoidance_enabled(false)
