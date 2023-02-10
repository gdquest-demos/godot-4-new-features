extends Node2D

@onready var _invisible_wall: TileMap = $InvisibleWalls


func _ready() -> void:
	_invisible_wall.visible = false
