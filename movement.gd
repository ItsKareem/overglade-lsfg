extends CharacterBody2D

@onready var anim := $AnimatedSprite2D
@export var speed := 100.0
@export var sword: Node2D
var last_direction := "down"
var is_attacking := false

func attack(last_direction):
	if is_attacking:
		return

	is_attacking = true
	
	anim.play("attack_" + last_direction)
	sword.start_attack(last_direction)
	# duration of the stab / attack
	var stab_time := 0.2
	await get_tree().create_timer(stab_time).timeout

	is_attacking = false
	

func _physics_process(delta: float) -> void:

	var input_vector := Vector2(
		Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		)

	if Input.is_action_just_pressed("attack"):
		attack(last_direction)


	var move_direction := input_vector.normalized()

	velocity = speed * move_direction

	move_and_slide()

	if move_direction.length() > 0:
		if abs(move_direction.x) > abs(move_direction.y):
			if move_direction.x > 0:
				if last_direction != "right":
					anim.play("turn_right")
					last_direction = "right"
					await anim.animation_finished
				anim.play("move_right")
				last_direction = "right"
			else:
				if last_direction != "left":
					anim.play("turn_left")
					last_direction = "left"
					await anim.animation_finished
				anim.play("move_left")
				last_direction = "left"
		else:
			if move_direction.y > 0:
				if last_direction != "down":
					anim.play("turn_down")
					last_direction = "down"
					await anim.animation_finished
				anim.play("move_down")
				last_direction = "down"
			else:
				if last_direction != "up":
					anim.play("turn_up")
					last_direction = "up"
					await anim.animation_finished
				anim.play("move_up")
				last_direction = "up"
	else:
		# No movement → Play idle animation based on last direction
		anim.play("idle_" + last_direction)
