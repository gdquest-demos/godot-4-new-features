extends Resource
class_name DemoData

@export var title := ""
@export var thumbnail: Texture2D = null
@export_file var scene_path := ""
@export_multiline var description := ""

static func setup(initial_title: String, intial_texture: Texture2D, initial_path: String, initial_description: String) -> DemoData:
	assert(FileAccess.file_exists(initial_path), "The scene at path %s was not found." % initial_path)

	var data := DemoData.new()
	data.title = initial_title
	data.thumbnail = intial_texture
	data.scene_path = initial_path
	data.description = initial_description
	return data
