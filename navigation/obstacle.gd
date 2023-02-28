extends CharacterBody3D


var _rng := RandomNumberGenerator.new()
var _tween: Tween
var _movement: Vector3 = Vector3.FORWARD
var _time := 0.0

@onready var navigation_obstacle := $NavigationObstacle3D


func _ready() -> void:
	_rng.randomize()
#	move()

func _physics_process(delta):
	_time += delta
	velocity = Vector3.FORWARD * sin(_time) * 3.0
	move_and_slide()


#func move() -> void:
#	if _tween != null:
#		_tween.kill()
#
#	var duration :=_rng.randf_range(0.8, 1.6)
#	var new_position := Vector3(_rng.randf_range(-0.5, 4), 0.95, _rng.randf_range(-2.5, 5))
#	# Todo: remove?
#	var velocity := (new_position - position) / duration
#	var obstacle_rid: RID = navigation_obstacle.get_rid()
#	NavigationServer3D.agent_set_velocity(obstacle_rid, velocity)
#	NavigationServer3D.agent_set_target_velocity(obstacle_rid, velocity)
#	_tween = create_tween()
#	_tween.tween_property(self, "position", new_position, duration)
#	await _tween.finished
#	move()
