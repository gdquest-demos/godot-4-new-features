extends Node2D
class_name PlayerSkin

var _current_state := "Idle" : get = get_current_state
var _treshhold := 0.01

@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _playback: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")


func get_current_state() -> String:
	return _current_state


func set_blend_position(blend_position: Vector2, speed: float = 1.0) -> void:
	if blend_position.length() > _treshhold:
		_animation_tree.set("parameters/" + _current_state + "/blend_position", blend_position)
	
	if _current_state == "Move":
		_animation_tree.set("parameters/Move/0/TimeScale/scale", speed)
		_animation_tree.set("parameters/Move/1/TimeScale/scale", speed)
		_animation_tree.set("parameters/Move/2/TimeScale/scale", speed)
		_animation_tree.set("parameters/Move/3/TimeScale/scale", speed)


func play_animation(anim_name: String, _from_position: Vector2 = Vector2.ZERO) -> void:
	if anim_name == _current_state:
		return

	if not _animation_tree.active:
		_animation_tree.active = true
	_current_state = anim_name
	_playback.start(_current_state)
