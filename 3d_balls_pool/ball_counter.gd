extends Label

@export var balls_holder : Node3D


func _physics_process(_delta: float) -> void:
	text = "Ball count: %.0f" % balls_holder.get_child_count()
