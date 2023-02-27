extends Node3D

const GDBotFace = preload("gdbot_face.gd")

var walk_run_blending := 0.0: 
	set(value):
		walk_run_blending = value
		_animation_tree.set(_walk_run_blend_position, walk_run_blending)

# Set loop on some animation
@export var _force_loop : PackedStringArray
@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _main_state_machine : AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _walk_run_blend_position : String = "parameters/StateMachine/Walk/blend_position"
@onready var face: GDBotFace = %GDbotFace


func _ready() -> void:
	for animation_name in _force_loop:
		var anim : Animation = $gdbot/AnimationPlayer.get_animation(animation_name)
		anim.loop_mode = Animation.LOOP_LINEAR


func idle() -> void:
	_main_state_machine.travel("Idle")


func walk() -> void:
	_main_state_machine.travel("Walk")


func jump() -> void:
	_main_state_machine.travel("Jump")


func fall() -> void:
	_main_state_machine.travel("Fall")


func punch() -> void:
	_main_state_machine.travel("Punch")


func set_face(face_name: String) -> void:
	face.current_face = face_name
