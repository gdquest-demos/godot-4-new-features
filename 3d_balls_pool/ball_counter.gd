extends Label

@export var balls_holder : Node3D

func _physics_process(_delta):
	text = "Ball count: %.0f" % balls_holder.get_child_count()
