extends TextureRect

const GEM_SCENE = preload("gem/gem.tscn")

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	spawn_gems(2)


func spawn_gems(count := 1) -> void:
	for i in count:
		var gem = GEM_SCENE.instantiate()
		gem.position = Vector2(
			randf_range(256.0, size.x - 256.0),
			randf_range(256.0, size.y - 256.0)
		)
		gem.collected.connect(spawn_gems)
		call_deferred("add_child", gem)
