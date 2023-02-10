extends PanelContainer

var dialogue = {
	0: {
		"text": "Hey, [i]wake up![/i] It's time to make video games.",
		"expression": "neutral",
		"buttons":
		{
			"Let me sleep a little longer": 2,
			"Let's do it!": 1,
		}
	},
	1: {
		"text": "Great! Your first task will be to write a [b]dialogue tree[/b].",
		"expression": "neutral",
		"buttons":
		{
			"I'm not sure if i'm ready, but i will do my best": 3,
			"No, let me go back to sleep": 2,
		}
	},
	2: {
		"text": "Oh, come on! It'll be fun.",
		"expression": "sad",
		"buttons":
		{
			"No, really, let me go back to sleep": 0,
			"Alright, I'll try": 3,
		}
	},
	3: {
		"text": "That's the spirit! You can do it!\n[wave][b]YOU WIN[/b][/wave]",
		"expression": "happy",
		"buttons": {}
	}
}

@onready var texture_rect := $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var rich_text_label := $MarginContainer/VBoxContainer/HBoxContainer/RichTextLabel
@onready var buttons_column := $MarginContainer/VBoxContainer/ButtonsColumn


func _ready() -> void:
	show_line(0)


func show_line(id: int) -> void:
	var line_data: Dictionary = dialogue[id]
	set_text(line_data.text)
	set_expression(line_data.expression)

	for button in buttons_column.get_children():
		button.queue_free()

	if line_data.buttons:
		create_buttons(line_data.buttons)
	else:
		add_quit_button()


func set_text(new_text: String) -> void:
	rich_text_label.bbcode_text = new_text


func set_expression(expression: String) -> void:
	if expression == "sad":
		texture_rect.texture = preload("portraits/sophia_sad.png")
	elif expression == "happy":
		texture_rect.texture = preload("portraits/sophia_happy.png")
	else:
		texture_rect.texture = preload("portraits/sophia_neutral.png")


#ANCHOR:add_quit_button
func add_quit_button() -> void:
	var button := Button.new()
	button.text = "Quit"
	buttons_column.add_child(button)
	button.connect("pressed", get_tree().quit)


func create_buttons(buttons_data: Dictionary) -> void:
	for text in buttons_data:
		var button := Button.new()
		button.text = text
		buttons_column.add_child(button)
		var target_line_id: int = buttons_data[text]
		button.connect("pressed", show_line.bind(target_line_id))
