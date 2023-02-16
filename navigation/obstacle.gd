extends AnimatableBody3D


var _rng := RandomNumberGenerator.new()
var _tween

#@onready var navigation_obstacle := $NavigationObstacle3D


func _ready() -> void:
	_rng.randomize()
	move()


func move() -> void:
	if _tween != null:
		_tween.kill()

	var duration :=_rng.randf_range(0.8, 1.6)
	var new_position := Vector3(_rng.randf_range(-0.5, 4), 0.95, _rng.randf_range(-2.5, 5))
	var velocity := (new_position - position) / duration
#	var obstacle_rid: RID = navigation_obstacle.get_rid()
#	NavigationServer3D.agent_set_velocity(obstacle_rid, velocity)
#	NavigationServer3D.agent_set_target_velocity(obstacle_rid, velocity)
	_tween = create_tween()
	_tween.tween_property(self, "position", new_position, duration)
	await _tween.finished
	move()
