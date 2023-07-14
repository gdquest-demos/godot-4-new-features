extends Node3D

signal moving_platform_touched

const Beetle := preload("beetle_teleport.gd")

@onready var beetle: Beetle = %Beetle
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var patrol_points := [
	%PatrolPointB.global_position,
	%PatrolPointA.global_position,
]


func _ready() -> void:
	beetle.navigation_agent.link_reached.connect(
		func(details: Dictionary) -> void:
			beetle.stop()
			animation_player.play("teleport")
			await animation_player.animation_finished
			beetle.global_position = beetle.target_global_position
			animation_player.play_backwards("teleport")
			await animation_player.animation_finished
			beetle.start()
	)
	beetle.target_global_positions = patrol_points
