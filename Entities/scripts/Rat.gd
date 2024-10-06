extends Node2D

var mouse_ate = preload("res://Objects/textures/Food_chonk_rat.png")

var is_tame = false

func _ready():
	$Sprite.play()

func tame():
	is_tame = true
	$Sprite.visible = false
	$TameSprite.visible = true
	$TameSprite.play()

func _on_tame_area_area_entered(area:Area2D):
	var par = area.get_parent()

	if par.is_in_group("cheese"):
		$Die.play()
		par.get_node("Texture").texture = mouse_ate
		par.get_node("Texture").scale = Vector2(2, 2)
		par.remove_from_group("cheese")
		par.add_to_group("food")

		if is_tame:
			get_parent().has_rat = false
		else:
			get_parent().get_parent().drop()

		self.queue_free()
	elif is_tame and par.is_in_group("food"):
		get_parent().grabbed_food(par)