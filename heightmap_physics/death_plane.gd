extends Area3D


func _ready() -> void:
	body_entered.connect(
		func on_body_entered(body) -> void:
			if !body.is_in_group("destroyable"):
				return
			body.queue_free()
	)

