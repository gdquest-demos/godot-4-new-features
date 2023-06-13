extends Area2D


@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibilityNotifier2D


func _ready() -> void:
	visibility_notifier.screen_exited.connect(queue_free)


func _physics_process(delta: float) -> void:
	var speed := 1200.0
	var direction := Vector2.ZERO
	position += speed * direction * delta
