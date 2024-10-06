extends Node2D

var rng = RandomNumberGenerator.new()

var cheese = preload("res://Objects/textures/Food_cheese.png")
var foods = [
	preload("res://Objects/textures/Food_carrot.png"),
	preload("res://Objects/textures/Food_meat.png"),
	preload("res://Objects/textures/Food_onion.png"),
	preload("res://Objects/textures/Food_potato.png"),
]

var food = preload("res://Objects/Food.tscn")

var cchance = 70

func _ready():
	rng.randomize()

func add_food():
	var new = food.instantiate()

	if rng.randi_range(1, cchance) == 1:
		cchance = max(cchance - 1, 12)

		new.add_to_group("cheese")
		new.get_node("Texture").texture = cheese
	else:
		new.get_node("Texture").texture = foods[rng.randi_range(0, len(foods)-1)]
		new.rotation = rng.randf_range(-PI, PI)

	self.get_node("Start").add_child(new)

func _process(delta):
	for child in self.get_node("Start").get_children():
		child.progress += 40 * delta;

		if child.progress_ratio >= 1:
			self.get_node("Start").remove_child(child)
			self.get_node("Table").add_child(child)
			child.progress = 0

	for child in self.get_node("Table").get_children():
		child.progress += 30 * delta;

		if child.progress_ratio >= 1:
			child.queue_free()
