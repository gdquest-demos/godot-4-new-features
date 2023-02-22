

func _on_player_in_range(player: PlayerCharacter) -> Direction:
	var angle := player.global_position.angle_to(enemy.global_position)
	var direction := Direction.new(angle)
	return direction



func move_to_pos(player: PlayerCharacter, grid_pos: Vector2i) -> void:
	var real_world_position := grid_pos * cell_size
	var tween: Tween = player.create_tween()
	tween.tween_property(player, "global_position", real_world_position, 1)



















#############################################################################

var enemy := CharacterBody2D.new()
var cell_size := Vector2i(32, 32)


class PlayerCharacter extends CharacterBody2D:
	pass

class Direction:
	func _init(angle) -> void:
		pass
