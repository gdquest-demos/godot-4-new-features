extends CharacterBody3D


var speed := 10
var turning_speed := 5
var mouse_sensitivity := 0.5

@export var id := 0:
	set(value):
		id = value
		_apply_id()
		
@export var color := Color():
	set(value):
		color = value
		_apply_color()


@onready var camera_3d: Camera3D = %Camera3D
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %MultiplayerSynchronizer
@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D


func _ready() -> void:
	_apply_id()
	_apply_color()


func _physics_process(delta: float) -> void:
	if not multiplayer_synchronizer.is_multiplayer_authority():
		return
	
	var input_dir := Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction := (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
	global_position += direction * speed * delta
	global_rotation.y += input_dir.x * turning_speed * delta


func _apply_id() -> void:
	if not is_inside_tree():
		await ready
	multiplayer_synchronizer.set_multiplayer_authority(id)
	camera_3d.current = multiplayer_synchronizer.is_multiplayer_authority()


func _apply_color() -> void:
	if not is_inside_tree():
		await ready
	var material: StandardMaterial3D = mesh_instance_3d.material_override
	material.albedo_color = color
