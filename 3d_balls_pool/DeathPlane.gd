extends Area3D


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	body.queue_free()
