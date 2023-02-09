extends CharacterBody3D

signal path_end_reached

const PUFF_SCENE := preload("smoke_puff/smoke_puff.tscn")
const SPEED := 3.0


## This array represents a queue of the locations the agent will move towards.
## As the scene has moving platforms, some locations aren't reachable until the
## moving platform connects to the place the agent is.
var move_targets := []:
	set(new_move_targets):
		move_targets = new_move_targets
		set_physics_process(not move_targets.is_empty())
		_navigation_agent.target_position = move_targets.front().global_position

		if move_targets.is_empty():
			_beetle_skin.idle()
			path_end_reached.emit()
		else:
			_beetle_skin.walk()


@onready var _reaction_animation_player: AnimationPlayer = $ReactionLabel/AnimationPlayer
@onready var _detection_area: Area3D = $PlayerDetectionArea
@onready var _beetle_skin: Node3D = $BeetlebotSkin
@onready var _navigation_agent: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	_beetle_skin.idle()
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	# Wait for the next location to be accessible, for example, a moving platform.
	var next_location := _navigation_agent.get_next_path_position()
	if not _navigation_agent.is_target_reachable():
		_beetle_skin.idle()
		return

	_beetle_skin.walk()
	var global_look_position: Vector3 = move_targets.front().global_position
	global_look_position.y = global_position.y
	look_at(global_look_position)

	# I couldn't get _navigation_agent.is_target_reached() to return true, so going with a manual calculation.
	if global_position.distance_to(_navigation_agent.target_position) > 0.2:
		var direction := (next_location - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()
	else:
		move_targets = move_targets.slice(1)
		_navigation_agent.target_position = move_targets.front().global_position
