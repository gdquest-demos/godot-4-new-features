extends Node3D

const Beetle := preload("beetle_priority.gd")
const BeetleScene := preload("beetle.tscn")

const BEETLE_COUNT := 10
const BEETLE_PRIORITY_ALBEDO := Color(1.0, 0.25, 0.25)
const BEETLE_PRIORITY_EYES := Color(1.0, 0.0, 1.0, 0.078)


func _ready() -> void:
	var patrol_points_groups := []
	for patrol_points_group in %PatrolPointGroups.get_children():
		patrol_points_groups.append(patrol_points_group.get_children().map(func(pp: MeshInstance3D) -> Vector3: return pp.global_position))

	for index in range(BEETLE_COUNT):
		var beetle := BeetleScene.instantiate()
		beetle.set_script(Beetle)
		%Beetles.add_child(beetle)

		if index % 2 == 0:
			beetle.global_position = patrol_points_groups[0][0]
			beetle.navigation_agent.avoidance_priority = 1.0
			beetle.set_patrol_points(patrol_points_groups[0])
			beetle.skin.scale = 1.2 * Vector3.ONE

			var beetle_model: MeshInstance3D = beetle.skin.get_node("beetle_bot/Armature/Skeleton3D/Beetle")
			beetle_model.get_surface_override_material(0).albedo_color = BEETLE_PRIORITY_ALBEDO
			beetle_model.get_surface_override_material(1).set_shader_parameter("screen_color", BEETLE_PRIORITY_EYES)
		else:
			beetle.global_position = patrol_points_groups[1][0]
			beetle.navigation_agent.avoidance_priority = 0.0
			beetle.set_patrol_points(patrol_points_groups[1])
			beetle.skin.scale = 0.8 * Vector3.ONE
