extends Node3D

signal moving_platform_touched

const Beetle := preload("beetle_moving_platforms.gd")

@export var moving_platform_is_touching := false

@onready var beetles: Node3D = %Beetles
@onready var moving_platform: Area3D = %MovingPlatform
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var patrol_points := [
	[
		%PatrolPointB.global_position,
		%PatrolPointA.global_position
	],
	[
		%PatrolPointA.global_position,
		%PatrolPointB.global_position
	],
]


func _ready() -> void:
	for index in range(beetles.get_child_count()):
		var beetle: Beetle = beetles.get_child(index)
		moving_platform_touched.connect(beetle.start)
		moving_platform.body_entered.connect(func(body: Node3D) -> void: body.is_on_platform = true)
		moving_platform.body_exited.connect(func(body: Node3D) -> void: body.is_on_platform = false)
		beetle.platform_reached.connect(animation_player.play)
		beetle.setup(moving_platform.get_child(index))
		beetle.target_global_positions = patrol_points[index]
