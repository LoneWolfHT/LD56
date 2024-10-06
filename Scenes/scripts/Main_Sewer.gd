extends Area2D

@onready var sewerstuff = get_parent().get_node("PlayerInfo")

var player = false

func _ready():
	sewerstuff.visible = false

func _process(_delta):
	if sewerstuff.visible:
		if Input.is_action_just_pressed("action"):
			get_parent().take_rat()

	if get_parent().has_rat and player and get_parent().get_node("Player").carrying == "":
		if !sewerstuff.visible:
			sewerstuff.get_node("Label").text = "Catch Rat (Space)"
			sewerstuff.visible = true
	elif sewerstuff.visible:
		sewerstuff.visible = false

func _on_sewerarea_entered(area:Area2D):
	if area.is_in_group("player_area"):
		player = true

func _on_area_exited(area:Area2D):
	if area.is_in_group("player_area"):
		player = false
