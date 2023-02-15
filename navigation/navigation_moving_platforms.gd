extends Node3D

# For a complete level we'd probably want to use a graph and the AStar pathfinding algorithm.
# But to keep the scene simple, we hard code the path the agent can take.
@onready var patrol_points := [$PatrolPointA, $PatrolPointB]
@onready var patrol_points_reverse := [$PatrolPointB, $PatrolPointA]
@onready var beetle1: CharacterBody3D = $Beetles/Beetle1
@onready var beetle2: CharacterBody3D = $Beetles/Beetle2
@onready var beetle3: CharacterBody3D = $Beetles/Beetle3
@onready var beetle4: CharacterBody3D = $Beetles/Beetle4
@onready var moving_platform_handler: Node3D = $MovingPlatformHandler



func _ready() -> void:
	# If our navigation mesh setup works correctly we do not need inbetween points, only the final position
	beetle1.move_targets = patrol_points_reverse
	beetle2.move_targets = patrol_points
	beetle3.move_targets = patrol_points_reverse
	beetle4.move_targets = patrol_points

	# for bettle 1 & 2 add the navigation layer 2 so they can use the NavigationLink3D that uses navigation layer 2
	beetle1._navigation_agent.set_navigation_layer_value(2, true)
	beetle2._navigation_agent.set_navigation_layer_value(2, true)


	# add debug labels to see platform state
	for bettle in $Beetles.get_children():
		var new_label_3d : Label3D = Label3D.new()
		new_label_3d.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		new_label_3d.double_sided = false
		new_label_3d.no_depth_test = true
		bettle.add_child(new_label_3d)
		new_label_3d.position.y = 1.7
		new_label_3d.name = "PlatformUsageStateLabel"
		bettle.agent_state_label = new_label_3d


func _on_button_pressed() -> void:
	moving_platform_handler.toggle()
