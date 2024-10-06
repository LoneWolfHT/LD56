extends Node2D

@export var has_rat := false

var rng = RandomNumberGenerator.new()

var rat_ent = preload("res://Entities/Rat.tscn")

@onready var rat = $RatSpawn/Path/PathF/Rat

func take_rat():
	if rat.visible:
		has_rat = false
		rat.visible = false
		$RatSpawn/RespawnTimer.start()

		var new = rat_ent.instantiate()

		$Player.carry(new)

func _ready():
	rng.randomize()

	rat.visible = false
	$RatSpawn/RespawnTimer.start()

	$"Game Over".visible = false
	$MainMenu.visible = true

	$Stats.text = ""

	get_tree().paused = true

	_on_stat_timer_timeout()

func _on_food_timer_timeout():
	var count = 1
	var working_count = 0

	for child in get_children():
		if child.is_in_group("ratpost"):
			count += 1

			if child.has_rat:
				working_count += 1

	if $Ratpost.has_rat:
		$Paths.add_food()

	$Paths/FoodTimer.start(count - working_count)

func _on_ratrespawn_timer_timeout():
	has_rat = true
	rat.visible = true
	rat.get_parent().progress_ratio = rng.randf()
	rat.play()

var served = 0
var failcount = 0
var FAIL_MAX = 10
func _on_stat_timer_timeout():
	$Stats.text = ("Served: %d\nFailed: %d/%d") % [served, failcount, FAIL_MAX]

func failed():
	failcount += 1
	$stopwait.play()

	if failcount >= FAIL_MAX:
		$"Game Over".show()
