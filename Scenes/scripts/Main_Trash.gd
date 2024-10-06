extends Area2D

var player = false

var small = preload("res://Objects/textures/Trash.aseprite")
var big = preload("res://Objects/textures/TrashGo.aseprite")

func _ready():
	$Here.visible = false

func _process(_delta):
	if get_parent().get_node("Player").carrying != "":
		$Here.visible = true

		if player:
			if Input.is_action_just_pressed("action"):
				player.drop(false).queue_free()
			elif $Here.sprite_frames != big:
				$Here.sprite_frames = big
				$Here.play()
		else:
			if $Here.sprite_frames != small:
				$Here.sprite_frames = small
				$Here.play()

	elif $Here.visible:
		$Here.visible = false

func _on_area_entered(area:Area2D):
	if area.is_in_group("player_area"):
		player = area.get_parent()


func _on_area_exited(area:Area2D):
	if area.is_in_group("player_area"):
		player = false
