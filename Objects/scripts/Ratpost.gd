extends Node2D

@export var has_rat := false

@onready var plate = get_node_or_null("output")

var player = false

func _ready():
	$Placehere.visible = false
	$Placego.visible = false
	$Placego.play()
	$Placehere.play()

	var extra = get_node_or_null("extra")
	if extra:
		extra.visible = false

func grabbed_food(food):
	if plate and plate.foodready and plate.foods < plate.MAX_FOODS:
		food.get_parent().remove_child(food)
		food.remove_from_group("food")
		food.progress = 0
		food.position = Vector2.ZERO
		plate.add_food(food)

	# score for feeding customers, score target, engame can be giant rat eating ratsaurant or something

func _process(_delta):
	if get_parent().get_node("Player").carrying == "rat" and not has_rat:
		$Placego.visible = not not player
		$Placehere.visible = not player
	elif $Placego.visible or $Placehere.visible:
		$Placego.visible = false
		$Placehere.visible = false

	if not has_rat and player and player.carrying == "rat" and Input.is_action_just_pressed("action"):
		var rat = player.drop()

		rat.rotation = 0
		rat.tame()
		self.add_child(rat)
		has_rat = true

		var extra = get_node_or_null("extra")
		if extra:
			extra.visible = true

func _on_area_2d_area_entered(area:Area2D):
	if area.is_in_group("player_area"):
		player = area.get_parent()

func _on_area_2d_area_exited(area:Area2D):
	if area.is_in_group("player_area"):
		player = false
