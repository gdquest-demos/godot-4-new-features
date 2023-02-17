extends Area3D


func _ready() -> void:
	body_entered.connect(
		func on_body_entered(body: Node3D) -> void:
			if not body.is_in_group("destroyable"):
				return
			body.queue_free()
	)

