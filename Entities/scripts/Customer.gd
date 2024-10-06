extends PathFollow2D

enum STATE { ENTERING, WAITING, EATING, LEAVING }
@export var mystate: STATE = STATE.ENTERING

@export var eating_timer = 6

var rng = RandomNumberGenerator.new()

var skins = [
	preload("res://Entities/textures/Customer1.aseprite"),
	preload("res://Entities/textures/Customer2.aseprite"),
	preload("res://Entities/textures/Customer3.aseprite"),
	preload("res://Entities/textures/Customer4.aseprite"),

	preload("res://Entities/textures/CustomerSTRONK.aseprite"),
]
var STRONK = false

func _ready():
	rng.randomize()

	if rng.randi_range(1, 40) == 1:
		STRONK = true
		$Sprite.sprite_frames = skins[len(skins)-1]
	else:
		$Sprite.sprite_frames = skins[rng.randi_range(0, len(skins)-2)]

	$Sprite.play()

func _on_waiting_timer_timeout():
	get_tree().get_current_scene().failed()
	mystate = STATE.LEAVING
