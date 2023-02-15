extends AnimatableBody3D


var _rng := RandomNumberGenerator.new()

@onready var _tween


func _ready() -> void:
	_rng.randomize()
	move()


func move() -> void:
	if _tween != null:
		_tween.kill()

	var duration :=_rng.randf_range(0.8, 1.6)
	var new_position := Vector3(_rng.randf_range(-0.5, 4), 0.95, _rng.randf_range(-2.5, 5))
	_tween = create_tween()
	_tween.tween_property(self, "position", new_position, duration)
	await _tween.finished
	move()
