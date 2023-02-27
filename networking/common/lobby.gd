@tool
extends Control

const MultiplayerSettings = preload("multiplayer_settings.gd")

signal game_start_requested

@export var minimal_amount_of_players := 2

@export var multiplayer_settings: Node = null:
	set(value):
		if value is MultiplayerSettings:
			multiplayer_settings = value
		update_configuration_warnings()


@onready var address_line_edit: LineEdit = %AddressLineEdit
@onready var port_line_edit: LineEdit = %PortLineEdit
@onready var nick_line_edit: LineEdit = %NickLineEdit
@onready var player_color_picker_button: ColorPickerButton = %PlayerColorPickerButton
@onready var is_server_check_button: CheckButton = %IsServerCheckButton
@onready var status_option_button: OptionButton = %StatusOptionButton
@onready var connect_button: Button = %ConnectButton


func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	assert(_get_configuration_warnings().size() == 0, ", ".join(_get_configuration_warnings()))

	nick_line_edit.text = multiplayer_settings.nickname
	nick_line_edit.text_changed.connect(
		func on_nick_changed(new_nick: String) -> void:
			multiplayer_settings.nickname = new_nick
	)

	var picker: ColorPicker = player_color_picker_button.get_picker()
	picker.color_modes_visible = false
	picker.presets_visible = false
	picker.sampler_visible = false
	picker.color_mode = ColorPicker.MODE_OKHSL
	picker.picker_shape = ColorPicker.SHAPE_OKHSL_CIRCLE

	player_color_picker_button.color = multiplayer_settings.color
	player_color_picker_button.color_changed.connect(
		func on_color_changed(new_color: Color):
			multiplayer_settings.color = new_color
	)

	address_line_edit.text = multiplayer_settings.address

	address_line_edit.text_changed.connect(
		func on_address_changed(new_address: String) -> void:
			multiplayer_settings.address = new_address
	)
	
	port_line_edit.text = str(multiplayer_settings.port)

	port_line_edit.text_changed.connect(
		func on_port_changed(new_port: String) -> void:
			new_port = new_port if new_port.is_valid_int() else str(multiplayer_settings.port)
			port_line_edit.text = new_port
			multiplayer_settings.port = new_port.to_int()
	)
	
	is_server_check_button.button_pressed = multiplayer_settings.is_server
	is_server_check_button.toggled.connect(
		func on_server_status_changed(toggle: bool) -> void:
			multiplayer_settings.is_server = toggle
			_update_buttons()
	)
	
	status_option_button.clear()
	for key in MultiplayerSettings.STATUS:
		var item_id: int = MultiplayerSettings.STATUS[key]
		var item_label := (key as String).to_pascal_case().replace("_", " ")
		status_option_button.add_item(item_label, item_id)
	status_option_button.select(multiplayer_settings.status)

	multiplayer_settings.status_changed.connect(
		func on_status_changed():
			if not is_inside_tree():
				await ready
				_update_buttons()
			status_option_button.select(multiplayer_settings.status)
	)

	multiplayer_settings.player_added.connect(
		func on_player_added(_player) -> void:
			_update_buttons()
	)
	multiplayer_settings.player_removed.connect(
		func on_player_removed(_player) -> void:
			_update_buttons()
	)
	
	_update_buttons()
	
	#start_game_button.pressed.connect(emit_signal.bind("game_start_requested"))
	connect_button.pressed.connect(_on_connect_button_pressed)


func _on_connect_button_pressed() -> void:
	if multiplayer_settings.status == MultiplayerSettings.STATUS.CONNECTED \
	or multiplayer_settings.status == MultiplayerSettings.STATUS.CONNECTING:
		multiplayer_settings.end_session()
	else:
		multiplayer_settings.start_session()


func _update_buttons() -> void:
	connect_button.disabled = false
	#start_game_button.visible = multiplayer_settings.is_server
	#var remaining_players: int = minimal_amount_of_players - multiplayer_settings.players.size()
	#start_game_button.disabled = remaining_players > 0
	#start_game_button.text = "Start Game!" if remaining_players <= 0 else "Waiting for %s players"%[remaining_players]
	match multiplayer_settings.status:
		MultiplayerSettings.STATUS.CONNECTING:
			connect_button.disabled = true
		MultiplayerSettings.STATUS.CONNECTED:
			connect_button.text = "Disconnect"
		_:
			connect_button.text = "Host" if multiplayer_settings.is_server else "Join"



func _get_configuration_warnings() -> PackedStringArray:
	var errors: PackedStringArray = [
		[ multiplayer_settings != null, "A multiplayer node is required" ],
		[ multiplayer_settings is MultiplayerSettings, "The node is required to be an instance of MultiplayerSettings" ]
	].reduce(
		func(arr: PackedStringArray, tuple: Array) -> PackedStringArray:
			if not tuple[0]: arr.append(tuple[1])
			return arr, 
		PackedStringArray()
	)
	return errors
