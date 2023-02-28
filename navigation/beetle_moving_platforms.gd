extends CharacterBody3D


signal path_end_reached

const SPEED := 3.0

## This array represents a queue of the locations the agent will move towards.
## As the scene has moving platforms, some locations aren't reachable until the
## moving platform connects to the place the agent is.
var move_targets := []:
	set(new_move_targets):
		move_targets = new_move_targets
		patrol_points = new_move_targets
		set_physics_process(not move_targets.is_empty())

		if move_targets.is_empty():
			_beetle_skin.idle()
			path_end_reached.emit()
		else:
			set_movement_target(move_targets[0].global_position)
			_beetle_skin.walk()

@onready var _beetle_skin: Node3D = %BeetlebotSkin
@onready var _navigation_agent: NavigationAgent3D = %NavigationAgent3D


var agent_state_label: Label3D

var platform_handler
var platform_handler_link : NavigationLink3D
var platform_exit_is_link_start_position : bool = false
var platform_travel_stage : int = 0

# bettle character was not at origin so all position checks required an offset
var beetle_position_offset : Vector3 = Vector3(0.0, 0.0, 0.0)

var patrol_points : Array = []
var patrol_inx : int = 0
var movement_target : Vector3

var link_enter_position : Vector3
var link_exit_position : Vector3
var main_movement_target : Vector3
var sub_movement_target : Vector3
var actor_rotation_on_enter : Vector3


func set_movement_target(_movement_target : Vector3):
	main_movement_target = _movement_target
	_navigation_agent.target_position = main_movement_target


enum {
	PLATFORMTRAVELSTAGE_NONE = 0,
	PLATFORMTRAVELSTAGE_WAITING_TO_ENTER,
	PLATFORMTRAVELSTAGE_ENTERING,
	PLATFORMTRAVELSTAGE_WAITING_TO_EXIT,
	PLATFORMTRAVELSTAGE_EXITING,
}


func _ready() -> void:
	_navigation_agent.connect("link_reached", _on_navigation_agent_3d_link_reached)
	_navigation_agent.connect("navigation_finished", _on_navigation_agent_3d_navigation_finished)
	_beetle_skin.idle()
	set_physics_process(false)


func _physics_process(delta: float) -> void:

	if is_using_platform(delta):
		# We are using a platform, let actor and platform handler do their thing
		return

	if _navigation_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		global_position = global_position
		_beetle_skin.idle()
		return

	_beetle_skin.walk()

	var current_path_index : int = _navigation_agent.get_current_navigation_path_index()
	var current_navigation_path : PackedVector3Array = _navigation_agent.get_current_navigation_path()

	var global_look_position: Vector3
	# look ahead along path if possible to avoid jittering backwards when overshooting path point
	if current_path_index + 1 < current_navigation_path.size() and false:
		global_look_position = current_navigation_path[current_path_index + 1]
	# can't look ahead try current path point
	elif current_path_index < current_navigation_path.size():
		global_look_position = current_navigation_path[current_path_index]
	# if all else fails look one world unit in front of our current rotation to avoid looking backward
	else:
		global_look_position = global_position - transform.basis.z
	global_look_position.y = global_position.y
	look_at(global_look_position)

	var _next_path_position : Vector3 = _navigation_agent.get_next_path_position()
	var direction : Vector3 = (_next_path_position - global_position).normalized()

	velocity = direction * SPEED
	move_and_slide()


func print_platform_usage_state():
	match platform_travel_stage:
		PLATFORMTRAVELSTAGE_NONE:
			agent_state_label.text = ""
		PLATFORMTRAVELSTAGE_WAITING_TO_ENTER:
			agent_state_label.text = "WAITING TO ENTER PLATFORM"
		PLATFORMTRAVELSTAGE_ENTERING:
			agent_state_label.text = "ENTERING PLATFORM"
		PLATFORMTRAVELSTAGE_WAITING_TO_EXIT:
			agent_state_label.text = " WAITING TO EXIT PLATFORM"
		PLATFORMTRAVELSTAGE_EXITING:
			agent_state_label.text = "EXITING PLATFORM"


func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	# We reached the position in the path that is mapped to a NavigationLink3D start / end position
	# Since the link does not move us this is the start of our movement through the moving platform handler
	# Normal movement need to be suspended and original target position remembered for later

	platform_handler_link = details.owner
	platform_handler = details.owner.get_parent()

	# A NavigationLink3D can be bidirectional so it is not clear what is a start / end position without checking distances
	var _global_link_start_position : Vector3 = platform_handler_link.global_transform * platform_handler_link.start_position
	var _global_link_end_position : Vector3 = platform_handler_link.global_transform * platform_handler_link.end_position

	if details.position.distance_to(_global_link_start_position) < details.position.distance_to(_global_link_end_position):
		link_enter_position = _global_link_start_position
		link_exit_position = _global_link_end_position
	else:
		link_enter_position = _global_link_end_position
		link_exit_position = _global_link_start_position

	sub_movement_target = _navigation_agent.target_position
	platform_travel_stage = PLATFORMTRAVELSTAGE_WAITING_TO_ENTER


func cancel_platform_use():
	platform_travel_stage = PLATFORMTRAVELSTAGE_NONE
	if platform_handler:
		_navigation_agent.target_position = sub_movement_target
		if platform_handler.can_user_leave_platform(self):
			pass
		else:
			# guess bettle is doomed now
			platform_handler = null


func is_using_platform(delta: float):
	match platform_travel_stage:
		PLATFORMTRAVELSTAGE_WAITING_TO_ENTER:
			wait_for_platform_enter(delta)
		PLATFORMTRAVELSTAGE_ENTERING:
			move_on_platform(delta)
		PLATFORMTRAVELSTAGE_WAITING_TO_EXIT:
			wait_for_platform_exit(delta)
		PLATFORMTRAVELSTAGE_EXITING:
			move_from_platform(delta)

	print_platform_usage_state()

	return platform_travel_stage !=  PLATFORMTRAVELSTAGE_NONE


func wait_for_platform_enter(_delta: float):
	_beetle_skin.idle()
	if platform_handler.is_disabled():
		cancel_platform_use()
		return
	if platform_handler.is_platform_ready_to_enter(self, link_enter_position):
		platform_travel_stage =  PLATFORMTRAVELSTAGE_ENTERING
		platform_handler.wait_for_platform_user(self)


func is_platform_ready_to_exit() -> bool:
	return platform_handler.is_platform_ready_to_exit(self, link_exit_position)


func move_on_platform(_delta: float) -> void:
	_beetle_skin.walk()
	platform_handler.wait_for_platform_user(self)

	if platform_handler.is_disabled():
		# platform was turned off, go back to where we entered
		var direction : Vector3 = (link_enter_position - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()
		# if we reach where we entered continue normal path movement
		if global_position.distance_to(link_enter_position) < _navigation_agent.path_desired_distance:
			continue_path()
	else:
		# move to the position on the platform that is designed as an attachment position
		var attachment_point : Node3D = platform_handler.get_attachment_point(self)
		var attachment_point_position : Vector3 = attachment_point.global_position

		var direction : Vector3 = (attachment_point_position - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()

		if global_position.distance_to(attachment_point_position) < _navigation_agent.path_desired_distance:
			actor_rotation_on_enter = rotation
			platform_travel_stage = PLATFORMTRAVELSTAGE_WAITING_TO_EXIT


func wait_for_platform_exit(_delta: float) -> void:
	_beetle_skin.idle()
	if platform_handler.is_disabled() and platform_handler.can_user_leave_platform(self):
		var closest_exit_position : Vector3 = platform_handler.get_user_closest_exit_position(self)
		var direction : Vector3 = (closest_exit_position - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()

		if global_position.distance_to(closest_exit_position) < _navigation_agent.path_desired_distance:

			continue_path()
	else:
		var attachment_point : Node3D = platform_handler.get_attachment_point(self)
		var attachment_point_rotation : Vector3 = attachment_point.global_rotation
		var attachment_point_position : Vector3 = attachment_point.global_position

		global_position = attachment_point_position
		global_rotation = attachment_point_rotation + actor_rotation_on_enter

		if is_platform_ready_to_exit():
			platform_travel_stage =  PLATFORMTRAVELSTAGE_EXITING
			platform_handler.wait_for_platform_user(self)


func move_from_platform(_delta: float) -> void:
	_beetle_skin.walk()
	platform_handler.wait_for_platform_user(self)

	var direction : Vector3 = (link_exit_position - global_position).normalized()
	velocity = direction * SPEED
	move_and_slide()

	if global_position.distance_to(link_exit_position) < _navigation_agent.path_desired_distance:
		continue_path()


func continue_path() -> void:
	platform_travel_stage = PLATFORMTRAVELSTAGE_NONE
	agent_state_label.text = ""
	platform_handler = null
	platform_handler_link = null
	_navigation_agent.target_position = main_movement_target


func _on_navigation_agent_3d_navigation_finished() -> void:
	if patrol_points.size() == 0:
		return

	if patrol_inx == patrol_points.size():
		patrol_inx = 0

	main_movement_target = patrol_points[patrol_inx].global_position
	set_movement_target(main_movement_target)

	patrol_inx += 1
