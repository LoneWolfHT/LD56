extends CharacterBody2D

@export var PLAYER_SPEED := 18000#9000

var carrying = ""
func carry(x):
	if x.is_in_group("rat"):
		carrying = "rat"
		x.rotation_degrees = 120
	elif x.is_in_group("plate"):
		carrying = "plate"
	elif x.is_in_group("foodplate"):
		carrying = "foodplate"
	else:
		return

	$pickup.play()

	x.position = Vector2(8, 12)
	$CollisionCarry.disabled = false
	$Carrying.add_child(x)
	$Sprite.play("carry")

func drop(good = true):
	if carrying != "":
		if not good:
			$trash.play()
		else:
			$place.play()

		var x = $Carrying.get_children().back()
		$Carrying.remove_child(x)

		$CollisionCarry.disabled = true
		carrying = ""
		return x

func _ready():
	$Sprite.play()
	$CollisionCarry.disabled = true

func _process(delta):
	velocity = Vector2(0, 0)

	if Input.is_action_pressed("up"):
		velocity.y -= PLAYER_SPEED * delta

	if Input.is_action_pressed("down"):
		velocity.y += PLAYER_SPEED * delta

	if Input.is_action_pressed("left"):
		velocity.x -= PLAYER_SPEED * delta

	if Input.is_action_pressed("right"):
		velocity.x += PLAYER_SPEED * delta

	if velocity.length() > 0:
		$Sprite.play("carry" if carrying != "" else "walk")
	else:
		$Sprite.pause()

	self.look_at(get_global_mouse_position())
	self.move_and_slide()