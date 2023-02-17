extends Button

@onready var texture_rect : TextureRect = %TextureRect
@onready var label : Label = $Label


func _ready() -> void:
	mouse_entered.connect(grab_focus)
