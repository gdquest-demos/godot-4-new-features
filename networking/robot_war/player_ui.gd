extends Control

@onready var player_name_label: Label = %PlayerNameLabel
@onready var damage_label: Label = %DamageLabel
@onready var portrait_background_color: ColorRect = %PortraitBackgroundColor

var _damage := 0.0


func set_player_name(player_name: String) -> void:
	player_name_label.text = player_name


func set_portrait_color(color: Color) -> void:
	portrait_background_color.color = color


func update_damage(damage: float) -> void:
	if _damage != damage:
		_damage = damage
		damage_label.text = "%0.0f" % _damage
