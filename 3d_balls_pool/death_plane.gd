extends Area3D


func _ready() -> void:
	body_entered.connect(
		func on_body_entered(body: PhysicsBody3D) -> void:
			body.queue_free()
	)
