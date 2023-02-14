extends Button

@onready var texture_rect : TextureRect = $VBoxContainer/TextureRect
@onready var label : Label = $VBoxContainer/Label


func _ready():
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	mouse_entered.connect(_on_mouse_entered)


func _on_mouse_entered() -> void:
	grab_focus()


func _on_focus_entered() -> void:
	pass


func _on_focus_exited() -> void:
	pass
