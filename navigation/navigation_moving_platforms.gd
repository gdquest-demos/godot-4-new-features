extends Node3D

signal moving_platform_touched

const Beetle = preload("beetle_moving_platforms.gd")

@onready var beetles: Node3D = %Beetles
@onready var moving_platform: NavigationRegion3D = %MovingPlatform
@onready var moving_platform_area: Area3D = moving_platform.get_node("Area3D")
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
		moving_platform_touched.connect(beetle.refresh)
		moving_platform_area.body_entered.connect(_on_moving_platform_area_body.bind(true))
		moving_platform_area.body_exited.connect(_on_moving_platform_area_body.bind(false))
		beetle.platform_reached.connect(_on_beetle_platform_reached)
		beetle.setup(%MovingPlatform.get_child(index))
		beetle.target_global_positions = patrol_points[index]


func _on_beetle_platform_reached() -> void:
	%AnimationPlayer.play()


func _on_moving_platform_area_body(body: Node3D, has_entered: bool) -> void:
	body.is_on_platform = body is Beetle and has_entered
