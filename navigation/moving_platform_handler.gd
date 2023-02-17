extends Node3D

# A NavigationLink3D tells the pathfinding that there is a path between the A and B position of the platform
# However, a NavigationLink3D does not tell a NavigationAgent HOW to move between A and B position, only that it CAN and at what COST
# This is what this "Handler" is for, together with platform handling functions on the NavigationAgent ..
# .. it manages how the NavigationAgent processes movement succesfully through the link to the other side
# This requires suspending the "normal" path movement to the main target position while the agent is using ..
# .. a platform or every one kind of gameplay interactable item that AI agents should use in pathfinding like a ladder, jumpad, ..
# After reaching the other side of the platform the suspended main path to the main target position can continue

# Without using a NavigationLink3D, everytime the navigation map changes due to e.g. platform navigation mesh reconnects it would trigger a repath
# A repath would make agents bounce back and forth trying to find a new valid shortest paths everytime ANY platform reconnects

@onready var moving_platform : Node3D = $MovingPlatformAnchor
@onready var moving_platform_navigation_link_3d: NavigationLink3D = $MovingPlatformNavigationLink3D
@onready var moving_platform_visual_mesh: MeshInstance3D = $MovingPlatformAnchor/MovingPlatformNavigationRegion3D/MovingPlatformVisualMesh
@onready var moving_platform_enter_a: Marker3D = $"MovingPlatformEnterA"
@onready var moving_platform_enter_b: Marker3D = $"MovingPlatformEnterB"
@onready var moving_platform_exit_a: Marker3D = $"MovingPlatformExitA"
@onready var moving_platform_exit_b: Marker3D = $"MovingPlatformExitB"
@onready var moving_platform_animation_player: AnimationPlayer = $MovingPlatformAnchor/AnimationPlayer
@onready var moving_platform_attachment_point: Marker3D = $MovingPlatformAnchor/MovingPlatformAttachmentPoint
@onready var moving_platform_wait_for_user_timer: Timer = $MovingPlatformWaitForUserTimer

@export var platform_connected_to_a : bool = false
@export var platform_connected_to_b : bool = false


var _is_enabled : bool = true


func _ready() -> void:
	moving_platform_visual_mesh.material_override.albedo_color = Color.GREEN


func is_enabled():
	return _is_enabled


func is_disabled():
	return !_is_enabled


func toggle():
	_is_enabled = !_is_enabled
	if _is_enabled:
		moving_platform_navigation_link_3d.enabled = true
		moving_platform_animation_player.play()
		moving_platform_visual_mesh.material_override.albedo_color = Color.GREEN
	else:
		moving_platform_navigation_link_3d.enabled = false
		moving_platform_animation_player.pause()
		moving_platform_visual_mesh.material_override.albedo_color = Color.RED


func is_platform_ready_to_enter(_platform_user : Node3D, enter_position: Vector3) -> bool:
	# 'platform_user' is not in use here but can be used for e.g. different enter conditions depending on the actor
	var platform_user_waits_on_a : bool = enter_position.distance_to(moving_platform_enter_a.global_position) < enter_position.distance_to(moving_platform_enter_b.global_position)

	if platform_user_waits_on_a:
		return platform_connected_to_a
	else:
		return platform_connected_to_b


func is_platform_ready_to_exit(_platform_user : Node3D, exit_position: Vector3) -> bool:
	# 'platform_user' is not in use here but can be used for e.g. different exit conditions depending on the actor
	var platform_user_exits_on_b : bool = exit_position.distance_to(moving_platform_exit_a.global_position) < exit_position.distance_to(moving_platform_exit_b.global_position)

	if platform_user_exits_on_b:
		return platform_connected_to_b
	else:
		return platform_connected_to_a


func get_attachment_point(_platform_user : Node3D) -> Node3D:
	# 'platform_user' is not in use here but can be used for e.g. assigning different positions depending on current users
	return moving_platform_attachment_point


func can_user_leave_platform(_platform_user : Node3D) -> bool:
	return platform_connected_to_a or platform_connected_to_b


func get_user_closest_exit_position(platform_user : Node3D) -> Vector3:
	var _closest_exit_position : Vector3
	if platform_connected_to_a:
		_closest_exit_position = moving_platform_enter_a.global_position
	elif platform_connected_to_b:
		_closest_exit_position = moving_platform_enter_b.global_position
	else:
		# should not happen when 'can_user_leave_platform()' is checked first
		_closest_exit_position = platform_user.global_position
	return _closest_exit_position


func wait_for_platform_user(_platform_user : Node3D) -> void:
	# This is a friendly platform, it waits while a user tries to enter / exit
	moving_platform_animation_player.pause()
	moving_platform_wait_for_user_timer.start(0.15)


func _on_moving_platform_wait_for_user_timer_timeout() -> void:
	if _is_enabled:
		moving_platform_animation_player.play()
	else:
		moving_platform_animation_player.pause()
