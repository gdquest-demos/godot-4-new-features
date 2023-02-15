extends Button

@onready var texture_rect : TextureRect = $VBoxContainer/TextureRect
@onready var label : Label = $VBoxContainer/Label


func _ready():
	mouse_entered.connect(grab_focus)
