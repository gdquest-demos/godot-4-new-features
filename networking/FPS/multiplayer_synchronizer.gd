extends MultiplayerSynchronizer


@export var y_rotation:float:
	set(val):
		if is_multiplayer_authority():
			y_rotation = val
		else:
			get_parent().rotation.y = val


@export var position:Vector3:
	set(val):
		if is_multiplayer_authority():
			position = val
		else:
			get_parent().position = val
