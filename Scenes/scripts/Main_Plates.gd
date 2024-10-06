extends Area2D

var player = false

func _process(_delta):
	if player and player.carrying == "":
		if Input.is_action_just_pressed("action"):
			player.carry($Plate.duplicate(DUPLICATE_GROUPS))
			# $Plate.visible = false

func _on_area_entered(area:Area2D):
	if area.is_in_group("player_area"):
		player = get_parent().get_node("Player")

func _on_area_exited(area:Area2D):
	if area.is_in_group("player_area"):
		player = false