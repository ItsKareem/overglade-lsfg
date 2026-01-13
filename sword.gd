extends Node2D

@export var stab_distance := 18.0
@export var stab_time := 0.2

@onready var sprite := $Sprite2D

var is_attacking := false

# Offsets relative to player for each direction
var attack_offsets = {
	"up": Vector2(0, -10),
	"down": Vector2(0, 10),
	"left": Vector2(-10, 0),
	"right": Vector2(10, 0)
}

var dir_vec := Vector2.ZERO

func _ready():
	sprite.visible = false

func start_attack(dir: String):
	if is_attacking:
		return

	is_attacking = true
	sprite.visible = true

	# Direction vector & rotation
	match dir:
		"right":
			dir_vec = Vector2.RIGHT
			rotation_degrees = 0
		"down":
			dir_vec = Vector2.DOWN
			rotation_degrees = 90
		"left":
			dir_vec = Vector2.LEFT
			rotation_degrees = 180
		"up":
			dir_vec = Vector2.UP
			rotation_degrees = 270

	# Initial offset relative to player
	position = attack_offsets.get(dir, Vector2.ZERO)

	# Thrust forward relative to the player
	position += dir_vec * stab_distance

	await get_tree().create_timer(stab_time).timeout

	# Return to offset
	position = attack_offsets.get(dir, Vector2.ZERO)
	sprite.visible = false
	is_attacking = false
