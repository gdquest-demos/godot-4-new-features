extends TextureRect

@onready var rich_text_label: RichTextLabel = %RichTextLabel

func _ready() -> void:
	rich_text_label.meta_clicked.connect(
		func(url: String) -> void:
			if url.begins_with("http"):
				OS.shell_open(url)
	)
