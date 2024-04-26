# GDQuest ColorPicker Presets

Reads a color presets `gpl` (GIMP Palette) file in the addon local directory, called `presets.gpl`. It adds the colors to the editor ColorPicker for quick access.

This repository includes a `presets.gpl` file as an example. It's the official GDQuest color palette.

## ✗ WARNING

> Compatible: Godot `>= v4.0`

The addon:

1. Doesn't check the length of the color palette/file.
1. Overwrites the _ColorPicker_ presets whenever you reopen the project or re-enable the addon.

## ✓ Install

### Manual

1. Copy the contents of this folder into `res://addons/gdquest_colorpicker_presets/`.
1. Replace `res://addons/colorpicker_presets/presets.gpl` with your preferred version.
1. Enable the addon from `Project > Project Settings... > Plugins`.
1. Profit.

### gd-plug

1. Install **gd-plug** using the Godot Asset Library.
1. Save the following code into the file `res://plug.gd` (create the file if necessary):

  ```gdscript
  #!/usr/bin/env -S godot --headless --script
  extends "res://addons/gd-plug/plug.gd"


  func _plugging() -> void:
  	plug(
  		"git@github.com:GDQuest/godot-addons.git",
  		{include = ["addons/gdquest_colorpicker_presets"]}
  	)
  ```

1. On Linux, make the `res://plug.gd` script executable with `chmod +x plug.gd`.
1. Using the command line, run `./plug.gd install` or `godot --headless --script plug.gd install`.

![install project settings](readme/install_project_settings.png)

## Where do I find the presets?

They'll be available in the editor _ColorPicker_.

![ColorPicker presets](readme/colorpicker_presets.png)

