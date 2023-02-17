class_name CameraController
extends Node3D

const CAMERA_LERP_VELOCITY = 0.1

## Player node
@export_node_path var player_path : NodePath
## Invert y rotation
@export var invert_mouse_y := false
## Camera mouse sensitivity
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
## Camera joystick sensitivity
@export_range(0.0, 8.0) var joystick_sensitivity := 2.0
## Max camera angle on the X axis 
@export var tilt_upper_limit := 0.48
## Min camera angle on the X axis
@export var tilt_lower_limit := -0.8
## Speed in which camera rotates to adapt to camera regions
@export var stage_camera_velocity := 0.3

@onready var _third_person_pivot: Node3D = $CameraSpringArm/CameraThirdPersonPivot
@onready var _camera: Camera3D = $PlayerCamera
@onready var _camera_raycast: RayCast3D = $PlayerCamera/CameraRayCast
@onready var _camera_spring_arm: SpringArm3D = $CameraSpringArm
@onready var _overlapping_regions := []

var _aim_target : Vector3
var _aim_target_normal : Vector3
var _aim_collider: Node
var _pivot: Node3D
var _rotation_input: float
var _tilt_input: float
var _mouse_input := false
var _offset: Vector3
var _anchor: Node3D
var _camera_rotation_lerp := 1.0
var _animating := false


func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity
		if invert_mouse_y:
			_tilt_input *= -1


func _physics_process(delta: float) -> void:
	if not _anchor or _animating:
		return
	
	# Get joystick tilt
	var raw_input := Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	_rotation_input += raw_input.x * joystick_sensitivity
	var analog_tilt := raw_input.y * joystick_sensitivity
	if invert_mouse_y:
		analog_tilt *= -1
	_tilt_input += analog_tilt
	
	if _camera_raycast.is_colliding():
		_aim_target = _camera_raycast.get_collision_point()
		_aim_target_normal = _camera_raycast.get_collision_normal()
		_aim_collider = _camera_raycast.get_collider()
	else:
		_aim_target = _camera_raycast.global_transform * _camera_raycast.target_position
		_aim_target_normal = (global_position - _aim_target).normalized()
		_aim_collider = null
	
	# Reset camera regions rotation if player is maneuvering the camera
	if _tilt_input != 0 or _rotation_input != 0:
		_camera_rotation_lerp = 0
	
	# Set camera controller to current ground level for the character
	var target_position := _anchor.global_position + _offset
	target_position.y = lerp(global_position.y, _anchor._ground_height, 0.1)
	global_position = target_position
	
	# Rotates camera using euler rotation
	var euler_rotation := basis.get_euler()
	euler_rotation.x += _tilt_input * delta
	euler_rotation.x = clamp(euler_rotation.x, tilt_lower_limit, tilt_upper_limit)
	euler_rotation.y += _rotation_input * delta
	euler_rotation.z = 0

	basis = Basis.from_euler(euler_rotation)
	
	_camera.global_transform = _camera.global_transform.interpolate_with(_pivot.global_transform, 0.5)
	_camera.rotation.z = 0

	_rotation_input = 0.0
	_tilt_input = 0.0


func _look_at_anchor(_seek: float) -> void:
	_camera.transform = _camera.transform.interpolate_with(_camera.transform.looking_at(_anchor.global_position), _seek)


func set_region(region: Area3D) -> void:
	_overlapping_regions.append(region)


func unset_region(region: Area3D) -> void:
	_overlapping_regions.erase(region)


func update_camera(player_pos: Vector3, delta: float) -> void:
	for region in _overlapping_regions:
		# Get difference between "ideal" camera angle (from camera region) and current camera angle
		var target_camera_direction: Vector3 = region.get_camera_target_position(player_pos)
		var current_radial_direction := (_third_person_pivot.global_position - _camera_spring_arm.global_position).normalized()
		var cross_radial := current_radial_direction.cross(target_camera_direction).normalized()
		var radial_angle := current_radial_direction.signed_angle_to(target_camera_direction, cross_radial)
		var dt_radial_angle := delta * stage_camera_velocity
		
		radial_angle = clampf(dt_radial_angle, -radial_angle, radial_angle)
		
		_camera_rotation_lerp = clamp(_camera_rotation_lerp + (delta * CAMERA_LERP_VELOCITY), 0.0, 1.0)
		dt_radial_angle = lerp(0.0, dt_radial_angle, _camera_rotation_lerp)
		basis = basis.slerp(basis.rotated(cross_radial, dt_radial_angle).orthonormalized(), 1)


func setup(anchor: CharacterBody3D) -> void:
	_anchor = anchor
	_offset = global_transform.origin - anchor.global_transform.origin
	_pivot = _third_person_pivot
	_camera.global_transform = _camera.global_transform.interpolate_with(_pivot.global_transform, 0.1)
	_camera_spring_arm.add_excluded_object(anchor.get_rid())


func play_end_animation() -> void:
	_animating = true
	
	var end_position := _camera.global_position
	var back_direction := (_camera.basis * Vector3.BACK)
	back_direction.y = 0.0
	back_direction = back_direction.normalized()
	end_position += (back_direction * 60) + (Vector3.UP * 60)
	
	var tween := create_tween()
	tween.tween_property(_camera, "global_position", end_position, 2.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_method(_look_at_anchor, 0.0, 1.0, 2.0)


func get_aim_target() -> Vector3:
	return _aim_target


func get_aim_target_normal() -> Vector3:
	return _aim_target_normal


func get_aim_collider() -> Node:
	if is_instance_valid(_aim_collider):
		return _aim_collider
	else:
		return null


func get_camera_basis() -> Basis:
	return _camera.basis
