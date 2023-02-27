class_name Player
extends CharacterBody3D

@export_group("Move speed")
## Maximum character movement speed
@export var move_speed := 8.0
## How fast the character will achieve its maximum movement speed
@export var acceleration := 3.0
## How fast the character stop moving if no input is given
@export var break_force := 12.0
## How fast it will change rotate its velocity in the xz plane
@export var turning_speed := 12.0
## Minimum velocity for the character, to avoid sliding
@export var stopping_speed := 1.0
## Minimum velocity for the character to slide when turning abruptly
@export var sliding_threshold_velocity := 5.5

@export_group("Jump and throwback")
## How easy is to change the jump's orthogonal force
@export var jump_orthogonal_control := 4
## How easy is to change jump's parallel force
@export var jump_parallel_control := 0.3
## Maximum falling speed
@export var terminal_velocity := 20
## First (simple) jump impulse
@export var first_jump_force := 9.0
## Number of frames the player can't change direction after touching the floor
@export var floor_inertia_frames := 5
## Number of frames the player can hold jump to go higher
@export var max_frames_holding_jump := 10
## Gravity force that affects the player
@export var gravity := 35

@export_group("Animation")
## How fast the model will turn to the body's direction
@export var rotation_speed := 12.0
## Minimum speed for the walking animation
@export var walk_anim_threshold := 0.5

@onready var camera_controller: CameraController = %CameraController
@onready var _rotation_root: Node3D = %CharacterRotationRoot
@onready var _ground_shapecast: ShapeCast3D = %GroundShapeCast
@onready var _character_skin: MiniSophiaSkin = %CharacterSkin
@onready var _floor_slide_particles: GPUParticles3D = %FloorSlideParticles
@onready var _step_sound: AudioStreamPlayer3D = %StepSounds

@onready var _ground_height: float = 0.0
@onready var _start_position := global_transform.origin

# States we have to store to control the character
@onready var _sliding_buffer := false
@onready var _ground_direction: Vector3
@onready var _frames_holding_jump := 0
@onready var _frames_on_floor := 0
@onready var _is_on_floor_buffer := false
@onready var _is_animating := false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_controller.setup(self)

func _physics_process(delta: float) -> void:
	
	# Calculate ground height for camera controller
	if _ground_shapecast.get_collision_count() > 0:
		for collision_result in _ground_shapecast.collision_result:
			_ground_height = max(_ground_height, collision_result.point.y)
	else:
		_ground_height = global_position.y + _ground_shapecast.target_position.y
	if global_position.y < _ground_height:
		_ground_height = global_position.y

	# We separate out the y velocity to not interpolate on the gravity
	var y_velocity := velocity.y
	velocity.y = 0.0

	# Get input and movement state
	var move_direction := _get_camera_oriented_input()
	var angle_to_move := velocity.signed_angle_to(move_direction, Vector3.UP)
	

	var is_just_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
	var is_air_boosting := Input.is_action_pressed("jump") and not is_on_floor() and y_velocity > 0.0
	var is_sliding: bool = is_on_floor() and abs(angle_to_move) > (PI/2) * 1.01 and (velocity.length() > sliding_threshold_velocity or _sliding_buffer)
	
	_sliding_buffer = is_sliding
	_is_on_floor_buffer = is_on_floor()
	
	# Count the frames the player is on the floor
	if is_on_floor():
		_frames_on_floor += 1
	
	# Horizontal movement logic
	if _is_animating:
		# Player can't move during animations
		pass
	elif velocity.is_zero_approx():
		velocity = velocity.lerp(move_direction * move_speed, acceleration * delta)
	else:
		if is_on_floor():
			if _frames_on_floor < floor_inertia_frames:
				# If the player just touched the floor after jumping, avoid 
				# making abrupt movements after controlling the character in 
				# mid-air.
				var dot_velocity := _ground_direction.dot(velocity)
				var minimum_length: float = max(stopping_speed, dot_velocity)
				velocity = _ground_direction * minimum_length
			
			elif is_sliding:
				velocity = velocity.lerp(Vector3.ZERO, acceleration * 2 * delta)
				if velocity.length() < stopping_speed:
					velocity = Vector3.ZERO
			else:
				var angle_to_clamped := clampf(angle_to_move, -turning_speed * delta, turning_speed * delta)
				velocity = velocity.rotated(Vector3.UP, angle_to_clamped)
				
				var velocity_length: float = clamp(velocity.length(), 0, move_speed)
				if move_direction.is_zero_approx():
					velocity_length = lerp(velocity_length, 0.0, break_force * delta)
				else:
					velocity_length = lerp(velocity_length, move_direction.length() * move_speed, acceleration * delta)
				velocity = velocity.normalized() * velocity_length
				
				if move_direction.length() == 0 and velocity.length() < stopping_speed:
					velocity = Vector3.ZERO
			
			if not velocity.is_zero_approx() and not is_just_jumping:
				_ground_direction = velocity.normalized()
			
		else:
			_ground_direction = _rotation_root.basis * Vector3.BACK
			
			var ortho_plane := Plane(_ground_direction)
			var ortho_movement := ortho_plane.project(move_direction)
			var parallel_movement := move_direction - ortho_movement

			var ortho_velocity := ortho_plane.project(velocity)
			var parallel_velocity := velocity - ortho_velocity
#
			ortho_velocity = ortho_movement * jump_orthogonal_control
			parallel_velocity += parallel_movement * jump_parallel_control
			parallel_velocity = parallel_velocity.limit_length(move_speed)

			velocity = ortho_velocity + parallel_velocity
	
	# Restore y velocity and calculate gravity
	var xz_velocity := Vector3(velocity.x, 0, velocity.z)
	velocity.y = y_velocity
	
	if _is_animating:
		# Gravity doesn't affect player during animations
		pass
	elif not is_on_floor():
		velocity += Vector3.DOWN * gravity * delta
	velocity.y = max(velocity.y, -terminal_velocity)

	# Check jump state
	if _is_animating:
		# Don't jump during animations
		pass
	elif is_just_jumping:
		_frames_holding_jump = 0
		_frames_on_floor = 0

		var jump_force := first_jump_force
			
		velocity.y = jump_force
			
		if not xz_velocity.is_zero_approx():
			_ground_direction = Vector3(velocity.x, 0.0, velocity.z).normalized()
	elif is_air_boosting:
		if _frames_holding_jump < max_frames_holding_jump:
			_frames_holding_jump += 1
			velocity.y += gravity * delta
	
	# Don't air boost anymore once player stop air boosting
	if not is_on_floor() and not is_air_boosting:
		_frames_holding_jump = 999
	
	# Check ledge grab state
	# The ledge grab mechanic is very physics dependant, so we need to be extra careful on
	# how we handle the player in a possible "bad" state (e.g. with geometry intersection)

	# Set character animation
	if is_just_jumping:
		_character_skin.jump()
	elif not is_on_floor() and velocity.y < 0:
		_character_skin.fall()
	elif is_on_floor():
		if xz_velocity.length() > walk_anim_threshold:
			_character_skin.walk()
			_character_skin.walk_run_blending = inverse_lerp(0.0, move_speed, xz_velocity.length()) 
		else:
			_character_skin.idle()
			_character_skin.walk_run_blending = 0.0
	
	# Set character orientation
	if _is_animating:
		# Don't turn character during animations
		pass
	elif is_just_jumping or is_sliding:
		if not move_direction.is_zero_approx():
			_orient_character_to_direction(move_direction, 9999.9 if is_just_jumping else delta)
	elif is_on_floor():
		_orient_character_to_direction(xz_velocity, delta)
	
	_floor_slide_particles.emitting = is_sliding
	
	if get_real_velocity().length() > 0.01:
		camera_controller.update_camera(global_position, delta)

	# Move and collide
	move_and_slide()


func play_random_foot_step_sound() -> void:
	_step_sound.pitch_scale = randfn(1.5, 0.2)
	_step_sound.play()


func reset_position() -> void:
	transform.origin = _start_position


func _get_camera_oriented_input() -> Vector3:
	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var input := Vector3.ZERO
	# This is to ensure that diagonal input isn't stronger than axis aligned input
	input.x = -raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = -raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	input = camera_controller.global_transform.basis * input
	input.y = 0.0
	return input.normalized()


func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var direction_normalized := direction.normalized()
	var forward_axis := -(_rotation_root.transform * Vector3.FORWARD).normalized()
	var angle_diff := forward_axis.signed_angle_to(direction_normalized, Vector3.DOWN)
	
	if not direction.is_zero_approx():
		var left_axis := Vector3.UP.cross(direction_normalized)
		var rotation_basis := Basis(left_axis, Vector3.UP, direction_normalized).orthonormalized().get_rotation_quaternion()
		var model_scale := _rotation_root.transform.basis.get_scale()
		_rotation_root.transform.basis = Basis(_rotation_root.transform.basis.get_rotation_quaternion().slerp(rotation_basis, min(1.0, delta * rotation_speed))).scaled(
			model_scale
		)
	
	if direction.is_zero_approx():
		var euler := _rotation_root.transform.basis.get_euler(2)
		euler.z = lerp(euler.z, 0.0, 0.1)
		_rotation_root.transform.basis = Basis.from_euler(euler)
	else:
		var inclined_angle: float = clampf(angle_diff, -0.05, 0.05)
		_rotation_root.transform.basis = _rotation_root.transform.basis.rotated(forward_axis, inclined_angle)
