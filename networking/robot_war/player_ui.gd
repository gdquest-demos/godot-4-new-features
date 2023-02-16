extends Control

@onready var player_name_label: Label = %PlayerNameLabel
@onready var damage_label: Label = %DamageLabel

var _damage := 0.0


func set_player_name(player_name: String) -> void:
	player_name_label.text = player_name


func update_damage(damage: float) -> void:
	if _damage != damage:
		_damage = damage
		damage_label.text = "%0.0f" % _damage
