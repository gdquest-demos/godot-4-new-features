extends Node3D

const Beetle = preload("beetle_move_to_position.gd")

@onready var camera_3d: Camera3D = %Camera3D
@onready var ray_cast_3d: RayCast3D = %RayCast3D
@onready var sphere: MeshInstance3D = %Sphere
@onready var beetle: Beetle = %Beetle
@onready var beetle_navigation_agent: NavigationAgent3D = beetle._navigation_agent

@onready var avoidance_toggle: CheckButton = %AvoidanceToggle
@onready var radius_slide: HSlider  = %RadiusSlider

@onready var line = %Line


func _ready() -> void:
	beetle_navigation_agent.path_changed.connect(_on_path_changed)
	avoidance_toggle.toggled.connect(_on_avoidance_toggled)
	radius_slide.value_changed.connect(_on_radius_value_changed)
	_on_avoidance_toggled(avoidance_toggle.button_pressed)
	_on_radius_value_changed(radius_slide.value)


func _on_path_changed() -> void:
	line.create_line(beetle_navigation_agent.get_current_navigation_path())


func _on_avoidance_toggled(toggled: bool) -> void:
	beetle.set_avoidance_enabled(toggled)


func _on_radius_value_changed(value: float) -> void:
	beetle.set_avoidance_radius(value)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		ray_cast_3d.target_position = camera_3d.project_ray_normal(get_viewport().get_mouse_position()) * 100.0
		if ray_cast_3d.is_colliding():
			sphere.global_position = ray_cast_3d.get_collision_point()
			beetle.target_global_position = sphere.global_position
