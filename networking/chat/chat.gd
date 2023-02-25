extends Control

const MultiplayerSettings = preload("../common/multiplayer_settings.gd")
const Lobby = preload("../common/lobby.gd")

@onready var lobby: Lobby = %Lobby
@onready var multiplayer_settings: MultiplayerSettings = %MultiplayerSettings
@onready var status_rich_text_label: RichTextLabel = %StatusRichTextLabel
@onready var send_message_button: Button = %SendMessageButton
@onready var message_line_edit: LineEdit = %MessageLineEdit
@onready var players_v_box_container: VBoxContainer = %PlayersVBoxContainer


func _ready() -> void:
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
	
	# make sure the buttons are in their disconnected state
	_on_disconnected()


func _on_message_submitted() -> void:
	var message := message_line_edit.text
	if message.length() == 0:
		return
	message_line_edit.text = ""
	dispatch_message(message)


func _on_connected():
	message_line_edit.editable = true
	send_message_button.disabled = message_line_edit.text.length() == 0


func _on_disconnected():
	message_line_edit.editable = false
	send_message_button.disabled = true


func _on_player_added(player: MultiplayerSettings.PeerPlayer) -> void:
	var label := Label.new()
	label.text = player.prefix + player.nickname
	label.add_theme_color_override("font_color", player.color)
	label.name = str(player.id)
	players_v_box_container.add_child(label)


func _on_player_removed(player_id: int) -> void:
	var label: Label = players_v_box_container.get_node(str(player_id))
	if label:
		label.queue_free()


## Dispatches a message to all players
func dispatch_message(message: String) -> void:
	_dispatch_message.rpc(message)


@rpc("any_peer", "call_local")
func _dispatch_message(message: String) -> void:
	var id := multiplayer.get_remote_sender_id()
	assert(multiplayer_settings.is_a_peer(id), "this method should only be called from an RPC context")
	var player := multiplayer_settings.get_player_by_id(id)
	if player == null:
		return
	var line = "[color={color}]{nickname}[/color]: {message}\n".format({
		color = player.color.to_html(),
		nickname = player.prefix + player.nickname,
		message = message,
	})
	status_rich_text_label.append_text(line)
