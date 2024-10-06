extends Node2D

var customer = false
var player = false

var gotfood = false

@onready var rootnode := get_tree().get_current_scene()

func _ready():
	$Placego.visible = false
	$Placehere.visible = false
	$Waiting.visible = false

	$Placego.play()
	$Placehere.play()
	$Waiting.play()

func _process(_delta):
	$Placehere.visible = false
	$Placego.visible = false
	$Waiting.visible = false

	if not gotfood:
		if rootnode.get_node("Player").carrying == "foodplate":
			if player:
				if Input.is_action_just_pressed("action"):
					gotfood = true
					if customer and customer.mystate == customer.STATE.WAITING:
						customer.mystate = customer.STATE.EATING
						customer.get_node("WaitingTimer").stop()
						rootnode.served += 1
					var new = player.drop()
					player.get_node("success").play()
					new.position = Vector2.ZERO
					$Attach.add_child(new)

				$Placego.visible = true
			else:
				$Placehere.visible = true
		elif customer and customer.mystate == customer.STATE.WAITING:
			$Waiting.visible = true

func _on_area_2d_area_entered(area:Area2D):
	if area.is_in_group("player_area"):
		player = area.get_parent()
	elif area.is_in_group("customer_area"):
		area.get_parent().look_at(self.position)
		customer = area.get_parent().get_parent()
		if gotfood:
			customer.mystate = customer.STATE.EATING
			customer.get_node("WaitingTimer").stop()
			rootnode.served += 1

func _on_area_2d_area_exited(area:Area2D):
	if area.is_in_group("player_area"):
		player = false
	elif area.is_in_group("customer_area"):
		if customer.mystate == customer.STATE.LEAVING and gotfood:
			gotfood = false
			$Attach.get_children().back().queue_free()
		customer = false
