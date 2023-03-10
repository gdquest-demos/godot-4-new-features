extends CharacterBody3D

const INVULNERABILITY_TICK_DURATION := 10
const JUMP_FORCE := 20.0
const GRAVITY_FORCE := 1.0

var speed := 10
var turning_speed := 0.01
var damage_tick := INVULNERABILITY_TICK_DURATION

@export var forward_speed := 0.0
@export var damage_amount := 0.0
@export var is_attacking := false

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
@onready var g_dbot_skin: Node3D = %GDbotSkin
@onready var label_3d: Label3D = %Label3D
@onready var damage_ray_cast: RayCast3D = %DamageRayCast


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
	damage_ray_cast.add_exception(self)
	
	get_parent().register_player(self)


func _physics_process(delta: float) -> void:
	_update_visuals()
	
	var is_authority := multiplayer_synchronizer.is_multiplayer_authority()
	
	if global_position.y < -1:
		damage_amount = 0.0
		if is_authority:
			global_position = Vector3(randf_range(-10, 10), 5, randf_range(-10, 10))
	
	if not is_authority:
		return
	
	damage_tick += 1
	is_attacking = Input.is_action_pressed("attack") and get_window().has_focus()
	var is_just_jumping = Input.is_action_just_pressed("jump") and get_window().has_focus()
	
	var vel_y = velocity.y
	velocity.y = 0.0
	
	if not is_on_floor():
		vel_y -= GRAVITY_FORCE
	elif is_just_jumping:
		vel_y = JUMP_FORCE
	
	if is_attacking:
		velocity = Vector3.ZERO
		var collider := damage_ray_cast.get_collider()
		if collider != null:
			if collider.has_method("damage"):
				collider.damage.rpc(global_position)
	
	elif is_on_floor() and damage_tick >= INVULNERABILITY_TICK_DURATION:
		var input_dir := Vector2.ZERO
		if get_window().has_focus():
			input_dir = Input.get_vector("move_right", "move_left", "move_down", "move_up")

		forward_speed = input_dir.y
		var direction := (transform.basis * Vector3(0, 0, forward_speed)).normalized()

		velocity = direction * speed
	
	velocity.y = vel_y
	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		global_rotation.y += -event.relative.x * turning_speed


@rpc("any_peer", "call_local")
func damage(origin: Vector3) -> void:
	if damage_tick < INVULNERABILITY_TICK_DURATION:
		return
	
	damage_tick = 0
	damage_amount += 5.0
	
	var punch_direction := global_position - origin
	punch_direction.y = 0.0
	var cross := punch_direction.normalized().cross(Vector3.UP)
	punch_direction = punch_direction.rotated(cross, PI/4.0)
	punch_direction = punch_direction.normalized()
	velocity = punch_direction * damage_amount


func _update_visuals() -> void:
	if is_attacking:
		g_dbot_skin.punch()
	else:
		g_dbot_skin.walk_run_blending = forward_speed
		if abs(forward_speed) < 0.001:
			g_dbot_skin.idle()
		else:
			g_dbot_skin.walk()


func _apply_color() -> void:
	if not is_inside_tree():
		await ready
	label_3d.modulate = color


func _apply_nickname() -> void:
	if not is_inside_tree():
		await ready
	label_3d.text = nickname
