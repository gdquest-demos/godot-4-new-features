extends CharacterBody3D

signal platform_reached

const SPEED := 3.0

var is_on_platform := false

var target_index := 0:
	set(value):
		target_index = wrapi(value, 0, target_global_positions.size())
		start()

var target_global_positions := []:
	set(value):
		target_global_positions = value
		if target_global_positions.is_empty():
			return
		start()

var remote_transform: RemoteTransform3D = null

@onready var beetle_skin: Node3D = %BeetlebotSkin
@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D


func setup(remote_transformm: RemoteTransform3D) -> void:
	remote_transform = remote_transformm


func _ready() -> void:
	navigation_agent.velocity_computed.connect(move)
	navigation_agent.navigation_finished.connect(stop)
	navigation_agent.max_speed = SPEED
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var next_location := navigation_agent.get_next_path_position()
	var direction := (next_location - global_position).normalized()
	var new_velocity := direction * SPEED
	navigation_agent.velocity = new_velocity
	if is_on_platform:
		stop()


func move(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	var current_model_transform := beetle_skin.global_transform
	beetle_skin.look_at(global_position + velocity, Vector3.UP, true)
	beetle_skin.global_transform = current_model_transform.interpolate_with(beetle_skin.global_transform, 10.0 * get_physics_process_delta_time())
	move_and_slide()


func start() -> void:
	is_on_platform = false
	set_physics_process(true)
	navigation_agent.avoidance_enabled = true
	remote_transform.remote_path = ^""
	navigation_agent.target_position = target_global_positions[target_index]
	beetle_skin.walk()


func stop() -> void:
	beetle_skin.idle()
	set_physics_process(false)
	navigation_agent.avoidance_enabled = false
	if global_position.distance_to(navigation_agent.target_position) < navigation_agent.path_desired_distance:
		target_index += 1
	elif is_on_platform:
		remote_transform.global_position = global_position
		remote_transform.global_rotation = global_rotation
		remote_transform.remote_path = remote_transform.get_path_to(self)
		platform_reached.emit()
