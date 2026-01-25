extends Node2D

@onready var fence_1 := $Fence
@onready var fence_2 := $Fence2

var challenge := 1
var room_active := false
var c1_counter := 0
var c2_counter := 0

func _process(_delta):
	if not room_active:
		return

	if get_tree().get_nodes_in_group("challenge_" + str(challenge)).is_empty():
		open_room()

func _on_player_detector_body_entered(body: Node2D) -> void:
	
	if c1_counter > 0:
		return
	
	challenge = 1
	if body.name != "Player" or room_active:
		return

	room_active = true

	fence_1.enter()
	fence_2.enter()

	c1_counter = c1_counter + 1

func open_room():
	room_active = false

	fence_1.exit()
	fence_2.exit()


func _on_player_detector_2_body_entered(body: Node2D) -> void:
	
	if c2_counter > 0:
		return
	
	challenge = 2
	if body.name != "Player" or room_active:
		return

	room_active = true

	fence_1.enter()
	fence_2.enter()

	c2_counter = c2_counter + 1
