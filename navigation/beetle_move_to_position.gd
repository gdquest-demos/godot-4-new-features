extends CharacterBody3D

const SPEED := 3.0

var target_global_position := Vector3.INF:
	set(new_target_global_position):
		target_global_position = new_target_global_position
		var is_near_target := global_position.distance_to(target_global_position) < _navigation_agent.target_desired_distance
		var has_new_target := not is_near_target and target_global_position != Vector3.INF
		set_physics_process(has_new_target)
		if has_new_target:
			_navigation_agent.target_position = target_global_position
			_beetle_skin.walk()


@onready var _beetle_skin: Node3D = %BeetlebotSkin
@onready var _navigation_agent: NavigationAgent3D = %NavigationAgent3D


func _ready() -> void:
	_navigation_agent.connect("velocity_computed", _on_navigation_agent_3d_velocity_computed)
	_navigation_agent.max_speed = SPEED
	_beetle_skin.idle()
	set_physics_process(false)


func _physics_process(_delta: float) -> void:
	# Wait for the next location to be accessible, for example, a moving platform.
	var next_location := _navigation_agent.get_next_path_position()

#	var global_look_position: Vector3 = target_global_position
#	global_look_position.y = global_position.y
	look_at(next_location)

	var direction := (next_location - global_position).normalized()
	_navigation_agent.set_velocity(direction * SPEED)
	if _navigation_agent.is_navigation_finished():
		_beetle_skin.idle()
		set_physics_process(false)


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()
