## Returns a dictionary of all arguments passed after `--` on the command line
## arguments take one of 2 forms:
## - `--arg` which is a boolean (using `--no-arg` for `false` is possible)
## - `--arg=value`. If the value is quoted with `"` or `'`, this function will
##    unsurround the string
## This function does no evaluation and does not attempt to guess the type of
## arguments. You will receive either bools, or strings.
func get_command_line_arguments() -> Dictionary:
	var unsurround := func unsurround(value: String, quotes := PackedStringArray(['"', "'"])) -> String:
		for quote_str in quotes:
			if value.begins_with(quote_str) \
			and value.ends_with(quote_str) \
			and value[value.length() - 2] != "\\":
				return value.trim_prefix(quote_str).trim_suffix(quote_str).strip_edges()
		return value

	var arguments := {}
	for argument in OS.get_cmdline_user_args():
		argument = argument.lstrip("--").to_lower()
		if argument.find("=") > -1:
			var arg_tuple := argument.split("=")
			var key := arg_tuple[0]
			var value:String = unsurround.call(arg_tuple[1])
			arguments[key] = value
		else:
			var key := argument
			var value := true
			if argument.begins_with("no-"):
				value = false
				key = argument.lstrip("no-")
			arguments[key] = value
	return arguments


## The scene selected from the command line with `-- --scene="name", if any
func get_selected_scene(command_line_arguments: Dictionary) -> PackedScene:
	var scene_name: String = command_line_arguments["scene"]
	var scene_path := "res://%s/%s.tscn"%[scene_name, scene_name]
	if not FileAccess.file_exists(scene_path):
		return null
	var scene: PackedScene = load(scene_path)
	return scene

var command_line_arguments := get_command_line_arguments()
var selected_scene := get_selected_scene(command_line_arguments)
