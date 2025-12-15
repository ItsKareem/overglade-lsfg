extends CharacterBody2D

@onready var anim := $AnimatedSprite2D
@export var speed := 100.0
var last_direction := "down"

func _physics_process(delta: float) -> void:

	var input_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)

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
