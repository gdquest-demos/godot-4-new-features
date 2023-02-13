extends TextureRect

const gem = preload("res://rewritten-tween-system/gem/gem.tscn")
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	spawn_gem(2)

	
func spawn_gem(count = 1) -> void:
	for i in count:
		var gem_instance = gem.instantiate()
		var newX = rng.randf_range(0 + 256, size.x - 256)
		var newY = rng.randf_range(0 + 256, size.y - 256)
		var newPos = Vector2(newX,newY)
		
		gem_instance.position = newPos	
		gem_instance.collected.connect(spawn_gem)
		call_deferred("add_child", gem_instance)
	
