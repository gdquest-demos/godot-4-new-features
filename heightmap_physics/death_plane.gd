extends Area3D


func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if !body.is_in_group("destroyable"): return
	body.queue_free()
