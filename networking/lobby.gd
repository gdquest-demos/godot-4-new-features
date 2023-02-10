@tool
extends Control

const MultiplayerSettings = preload("multiplayer_settings.gd")


# TODO: why can't this be specified as a MultiplayerSettings node?
# TODO: why aren't config warnings updated? Why isn't the setter called at all?
@export var multiplayer_settings: Node = null:
	set(value):
		if value is MultiplayerSettings:
			multiplayer_settings = value
		update_configuration_warnings()


@onready var address_line_edit: LineEdit = %AddressLineEdit
@onready var port_line_edit: LineEdit = %PortLineEdit
@onready var nick_line_edit: LineEdit = %NickLineEdit
@onready var is_server_check_button: CheckButton = %IsServerCheckButton
@onready var status_option_button: OptionButton = %StatusOptionButton
@onready var connect_button: Button = %ConnectButton
@onready var status_rich_text_label: RichTextLabel = %StatusRichTextLabel
@onready var message_line_edit: LineEdit = %MessageLineEdit
@onready var send_message_button: Button = %SendMessageButton
@onready var players_v_box_container: VBoxContainer = %PlayersVBoxContainer

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	
	assert(_get_configuration_warnings().size() == 0, ", ".join(_get_configuration_warnings()))

	nick_line_edit.text = multiplayer_settings.nickname
	nick_line_edit.text_changed.connect(
		func on_nick_changed(new_nick: String) -> void:
			multiplayer_settings.nickname = new_nick
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
			_update_button()
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
				_update_button()
			status_option_button.select(multiplayer_settings.status)
	)

	multiplayer_settings.status_message_emitted.connect(
		func on_new_message(message: String,  type: MultiplayerSettings.MESSAGE_TYPE):
			var color := Color.WHITE_SMOKE
			match type:
				MultiplayerSettings.MESSAGE_TYPE.ERROR:
					color = Color.ORANGE_RED
				MultiplayerSettings.MESSAGE_TYPE.WARNING:
					color = Color.ORANGE
				MultiplayerSettings.MESSAGE_TYPE.SUCCESS:
					color = Color.GREEN_YELLOW
			status_rich_text_label.append_text("[color=%s]%s[/color]\n"%[color.to_html(), message])
	)

	message_line_edit.text_changed.connect(
		func on_message_changed(new_text: String) -> void:
			send_message_button.disabled = new_text.length() == 0
	)
	
	message_line_edit.text_submitted.connect(
		func on_text_submitted(_new_text: String) -> void:
			_on_message_submitted()
	)
	send_message_button.pressed.connect(_on_message_submitted)
	message_line_edit.editable = false

	multiplayer_settings.connected.connect(_on_connected)
	multiplayer_settings.disconnected.connect(_on_disconnected)
	multiplayer_settings.player_added.connect(_on_player_added)
	multiplayer_settings.player_removed.connect(_on_player_removed)
	multiplayer_settings.player_sent_text.connect(_on_message_received)
	
	connect_button.pressed.connect(_on_connect_button_pressed)


func _on_connect_button_pressed() -> void:
	if multiplayer_settings.status == MultiplayerSettings.STATUS.CONNECTED \
	or multiplayer_settings.status == MultiplayerSettings.STATUS.CONNECTING:
		multiplayer_settings.end_session()
	else:
		multiplayer_settings.start_session()


func _update_button() -> void:
	connect_button.disabled = false
	match multiplayer_settings.status:
		MultiplayerSettings.STATUS.CONNECTING:
			connect_button.disabled = true
		MultiplayerSettings.STATUS.CONNECTED:
			connect_button.text = "Disconnect"
		_:
			connect_button.text = "Host" if multiplayer_settings.is_server else "Join"


func _on_message_submitted() -> void:
	var message := message_line_edit.text
	if message.length() == 0:
		return
	message_line_edit.text = ""
	multiplayer_settings.dispatch_message(message)


func _on_message_received(player: MultiplayerSettings.Player, message: String) -> void:
	var line = "[color={color}]{nickname}[/color]: {message}\n".format({
		color = player.color.to_html(),
		nickname = player.prefix + player.nickname,
		message = message,
	})
	status_rich_text_label.append_text(line)


func _on_connected():
	message_line_edit.editable = true
	send_message_button.disabled = message_line_edit.text.length() == 0


func _on_disconnected():
	message_line_edit.editable = false
	send_message_button.editable = false


func _on_player_added(player: MultiplayerSettings.Player) -> void:
	var label := Label.new()
	label.text = player.prefix + player.nickname
	label.add_theme_color_override("font_color", player.color)
	label.name = str(player.id)
	players_v_box_container.add_child(label)


func _on_player_removed(player_id: int) -> void:
	var label: Label = players_v_box_container.find_child(str(player_id))
	if label:
		label.queue_free()


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
