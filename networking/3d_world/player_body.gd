extends CharacterBody3D

var speed := 10
var turning_speed := 5
var mouse_sensitivity := 0.5

@export var color := Color():
	set(value):
		color = value
		_apply_color()

@export var nickname := "":
	set(value):
		nickname = value
		_apply_nickname()

@onready var camera_3d: Camera3D = %Camera3D
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %MultiplayerSynchronizer
@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D
@onready var label_3d: Label3D = %Label3D


func _enter_tree() -> void:
	# We need to set the authority before entering the tree, because by then,
	# we already have started sending data.
	if str(name).is_valid_int():
		var id := str(name).to_int()
		# Before ready, the variable `multiplayer_synchronizer` is not set yet
		%MultiplayerSynchronizer.set_multiplayer_authority(id)


func _ready() -> void:
	camera_3d.current = multiplayer_synchronizer.is_multiplayer_authority()
	label_3d.visible = not multiplayer_synchronizer.is_multiplayer_authority()


func _physics_process(delta: float) -> void:
	if not multiplayer_synchronizer.is_multiplayer_authority():
		return
	
	var input_dir := Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var alt_is_pressed := Input.is_key_pressed(KEY_ALT)
	var dir_forward := input_dir.y
	var dir_sides := input_dir.x if alt_is_pressed else 0.0
	var direction := (transform.basis * Vector3(dir_sides, 0, dir_forward)).normalized()
	global_position += direction * speed * delta
	if not alt_is_pressed:
		global_rotation.y += input_dir.x * turning_speed * delta


func _apply_color() -> void:
	if not is_inside_tree():
		await ready
	#prints("_apply_color", multiplayer_synchronizer.get_multiplayer_authority(), color)
	var material: StandardMaterial3D = mesh_instance_3d.material_override
	material.albedo_color = color


func _apply_nickname() -> void:
	if not is_inside_tree():
		await ready
	label_3d.text = nickname
