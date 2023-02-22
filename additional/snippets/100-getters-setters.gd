var title := "Dr"
var first_name := "Sophia"
var last_name := "Godot"


var full_name := "Dr Sophia Godot":
	set(value):
		var parts = value.split(" ")
		title = parts[0]
		first_name = parts[1]
		last_name = parts[2]
	get:
		return " ".join([title, first_name, last_name])
