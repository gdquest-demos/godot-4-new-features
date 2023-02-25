extends Node

@onready var thunder_light = %ThunderLight
@onready var thunder_timer = %ThunderTimer
@onready var thunder_sound = %ThunderSound

func _ready():
	thunder_timer.connect("timeout", _on_timeout)

func _on_timeout():
	var count = randi_range(1, 3)
	var t = create_tween()
	for i in range(count):
		var intensity = randf_range(0.2, 0.8)
		t.tween_property(thunder_light, "color:a", intensity, 0.1 * intensity)
		t.tween_property(thunder_light, "color:a", 0.0, 0.2 * intensity)
	
	await get_tree().create_timer(randf_range(0.4, 1.0)).timeout
	thunder_sound.play_random()
	thunder_timer.wait_time = randf_range(4.0, 12.0)
	thunder_timer.start()
