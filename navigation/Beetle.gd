extends CharacterBody3D

const PUFF_SCENE := preload("smoke_puff/smoke_puff.tscn")
const SPEED := 3.0

@export var stopping_distance := 0.0

var _target: Node3D = null

@onready var _reaction_animation_player: AnimationPlayer = $ReactionLabel/AnimationPlayer
@onready var _detection_area: Area3D = $PlayerDetectionArea
@onready var _beetle_skin: Node3D = $BeetlebotSkin
@onready var _navigation_agent: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	_detection_area.body_entered.connect(func (body: Node3D):
		if body:
			_target = body
			_reaction_animation_player.play("found_player")
	)
	_detection_area.body_exited.connect(func (body: Node3D):
		if body:
			_target = null
			_reaction_animation_player.play("lost_player")
	)
	_beetle_skin.idle()


func _physics_process(delta: float) -> void:
	if _target != null:
		_beetle_skin.walk()
		var target_look_position := _target.global_position
		target_look_position.y = global_position.y
		if target_look_position != Vector3.ZERO:
			look_at(target_look_position)

		_navigation_agent.target_position = _target.global_position

		var next_location := _navigation_agent.get_next_path_position()

		if not _navigation_agent.is_target_reached():
			var direction := (next_location - global_position)
			direction.y = 0
			direction = direction.normalized()
			velocity = direction * SPEED
			move_and_slide()
	else:
		_beetle_skin.idle()
