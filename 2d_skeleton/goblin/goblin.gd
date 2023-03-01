extends CanvasGroup

@onready var _animation_player = $AnimationPlayer

@onready var _hips = $Skeleton2D/Center/Hips
@onready var _skeleton = $Skeleton2D

@export var _h_flip = false

var _modification_stack : SkeletonModificationStack2D

var _flip_bend_R : SkeletonModification2DTwoBoneIK
var _flip_bend_L : SkeletonModification2DTwoBoneIK

func _ready():
	_modification_stack = _skeleton.get_modification_stack().duplicate(true)
	_skeleton.set_modification_stack(_modification_stack)
	_flip_bend_R = _modification_stack.get_modification(0)
	_flip_bend_L = _modification_stack.get_modification(1)
	_set_flip_h(_h_flip)
	
func idle():
	_animation_player.play("idle")
	
func run():
	_animation_player.play("run")
	
func _set_flip_h(value : bool):
	_h_flip = value
	if value:
		_hips.scale.y = -1.0
		_skeleton.scale.x = -1.0
	else:
		_hips.scale.y = 1.0
		_skeleton.scale.x = 1.0
		
	_flip_bend_R.flip_bend_direction = value
	_flip_bend_L.flip_bend_direction = value
