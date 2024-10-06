extends Node2D

var rng = RandomNumberGenerator.new()

@onready var tablepaths = [
	$Table1,
	$Table2,
	$Table3,
	$Table4,
]

var customer = preload("res://Entities/Customer.tscn")

var START_TIME = 20
var MIN_TIME = 5

func _ready():
	rng.randomize()

	$CustomerTimer.wait_time = START_TIME

func stop_for_player(c):
	if c.mystate != c.STATE.LEAVING:
		var stop = false
		for area in c.get_node("Sprite/StopCheck").get_overlapping_areas():
			if area.is_in_group("player_area"):
				if not c.STRONK:
					if area.get_parent().carrying == "rat":
						c.get_node("Sprite").flip_h = true
						c.look_at(area.get_parent().position)
				else:
					c.look_at(area.get_parent().position)

				stop = true
				break

			if area.is_in_group("customer_area"):
				for overlapping in c.get_node("Sprite/IgnoreCheck").get_overlapping_areas():
					if overlapping == area:
						stop = true

		if stop:
			c.get_node("Sprite").pause()
			return true

	c.get_node("Sprite").play()
	c.get_node("Sprite").flip_h = false
	c.rotation = 0

	return false

func _process(delta):
	# Walk to shop door
	for child in $Start.get_children():
		if !stop_for_player(child):
			child.progress += 60 * delta

			if child.progress_ratio >= 1:
				$Start.remove_child(child)
				tablepaths[rng.randi_range(0, len(tablepaths)-1)].add_child(child)
				child.progress = 0

	for table in tablepaths:
		for child in table.get_children():
			if !stop_for_player(child):
				#Go to table
				if child.mystate == child.STATE.ENTERING:
					child.progress += 60 * delta;

					if child.progress_ratio >= 1:
						child.mystate = child.STATE.WAITING
						child.get_node("WaitingTimer").start()
				#Eat
				elif child.mystate == child.STATE.EATING:
					child.eating_timer -= delta
					child.progress_ratio = 1
					child.get_node("Sprite").pause()

					if child.eating_timer <= 0:
						child.mystate = child.STATE.LEAVING
				# Leave Table
				elif child.mystate == child.STATE.LEAVING:
					child.progress -= 60 * delta;

					child.get_node("Sprite").play()

					child.get_node("Sprite").rotation_degrees = 180

					if child.progress_ratio <= 0:
						table.remove_child(child)
						$Leave.add_child(child)
						child.get_node("Sprite").rotation_degrees = 0

	#Leave
	for child in $Leave.get_children():
		if !stop_for_player(child):
			child.progress += 120 * delta

			if child.progress_ratio >= 1:
				child.queue_free()

func _on_customer_timer_timeout():
	var new = customer.instantiate()

	$CustomerTimer.wait_time = max(MIN_TIME, $CustomerTimer.wait_time - rng.randf_range(1, 2))

	$Start.add_child(new)
