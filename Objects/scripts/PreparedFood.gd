extends Node2D

var MAX_FOODS = 3
var foods = 0

var foodready = false

var player = false

@onready var rootnode := get_tree().get_current_scene()

func _ready():
	$Placego.visible = false
	$Placehere.visible = false
	$Placego.play()
	$Placehere.play()
	$Ready.visible = false
	$Sprite.visible = false

func add_food(food):
	$Sprite/Path.call_deferred("add_child", food)
	foods += 1

	if foods >= MAX_FOODS:
		$Ready.visible = true

func _process(_delta):
	if not foodready and rootnode.get_node("Player").carrying == "plate":
		if player:
			if Input.is_action_just_pressed("action"):
				$Sprite.visible = true
				foodready = true
				player.drop().queue_free()
			else:
				$Placego.visible = true
				$Placehere.visible = false
		else:
			$Placego.visible = false
			$Placehere.visible = true
	elif $Placego.visible or $Placehere.visible:
		$Placego.visible = false
		$Placehere.visible = false

	if foods >= MAX_FOODS and player and player.carrying == "":
		if Input.is_action_just_pressed("action"):
			var new = $Sprite.duplicate(DUPLICATE_GROUPS)

			for child in $Sprite/Path.get_children():
				child.queue_free()

			player.carry(new)
			foods = 0
			foodready = false
			$Ready.visible = false
			$Sprite.visible = false

func _on_player_detect_area_entered(area:Area2D):
	if area.is_in_group("player_area"):
		player = area.get_parent()

func _on_player_detect_area_exited(area:Area2D):
	if area.is_in_group("player_area"):
		player = false
