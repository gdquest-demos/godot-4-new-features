extends Panel

var texture: CompressedTexture2D : set = set_texture

@onready var _texture_rect := %TextureRect

func set_texture(new_texture: CompressedTexture2D) -> void:
	texture = new_texture
	_texture_rect.texture = texture
