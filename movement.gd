extends CharacterBody2D
class_name Player

signal healthChanged

@onready var anim := $AnimatedSprite2D
@onready var effects := $Effects
@onready var hurtTimer := $hurtTimer
@onready var hurtbox := $hurtbox
@onready var sword := $sword
@onready var sword_anim := $sword/AnimationPlayer

@export var speed := 100.0
@export var slash_time := 0.2
@export var sword_return_time := 0.5
@export var weapon_damage := 1.0
@export var maxHealth := 3
@export var knockbackPower := 600

var currentHealth := maxHealth
var canSlash := true
var is_attacking := false
var isHurt := false
var last_direction := "down"

const sword_slash_preload = preload("res://sword_slash.tscn")

func _ready() -> void:
	effects.play("RESET")
	sword.visible = false

func _physics_process(delta: float) -> void:

	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var move_direction := input_vector.normalized()

	velocity = move_direction * speed
	move_and_slide()

	if move_direction != Vector2.ZERO:
		if abs(move_direction.x) > abs(move_direction.y):
			if move_direction.x > 0:
				last_direction = "right"
				anim.play("move_right")
			else:
				last_direction = "left"
				anim.play("move_left")
		else:
			if move_direction.y > 0:
				last_direction = "down"
				anim.play("move_down")
			else:
				last_direction = "up"
				anim.play("move_up")
	else:
		anim.play("idle_" + last_direction)

	update_sword_draw_order()

	if Input.is_action_just_pressed("attack") and canSlash:
		$sword/AnimationPlayer.speed_scale = $sword/AnimationPlayer.get_animation("slash_" + last_direction).length / slash_time
		$sword/AnimationPlayer.play("slash_" + last_direction)
		start_attack()
	if !isHurt:
		for area in hurtbox.get_overlapping_areas():
			if area.name == "hitbox":
				hurtByEnemy(area)

func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth < 0:
		currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	isHurt = true
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash_" + last_direction:
		is_attacking = false
		$sword/AnimationPlayer.speed_scale = $sword/AnimationPlayer.get_animation("slash_" + last_direction).length / sword_return_time
		$sword/AnimationPlayer.play("sword_return_" + last_direction)
	else:
		canSlash = true

func get_facing_vector() -> Vector2:
	match last_direction:
		"up":
			return Vector2.UP
		"down":
			return Vector2.DOWN
		"left":
			return Vector2.LEFT
		"right":
			return Vector2.RIGHT
	return Vector2.DOWN


func spawn_slash():
	var slash = sword_slash_preload.instantiate()
	var spawn = $SlashMarker

	match last_direction:
		"right":
			slash.global_position = spawn.global_position + Vector2(24,0)
			slash.rotation = 0
		"down":
			slash.global_position = spawn.global_position + Vector2(0,24)
			slash.rotation = PI / 2
		"left":
			slash.global_position = spawn.global_position + Vector2(-24,0)
			slash.rotation = PI
		"up":
			slash.global_position = spawn.global_position + Vector2(0,-24)
			slash.rotation = -PI / 2
		
	get_parent().add_child(slash)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(weapon_damage)

func start_attack():
	canSlash = false
	is_attacking = true
	velocity = Vector2.ZERO
	update_sword_transform()
	update_sword_draw_order()
	anim.play("attack_" + last_direction)
	spawn_slash()

func update_sword_transform():
	match last_direction:
		"right":
			sword.rotation = 0
			sword.position = Vector2(9, 5)

		"down":
			sword.rotation = PI / 2
			sword.position = Vector2(-3, 7)

		"left":
			sword.rotation = PI
			sword.position = Vector2(-6, 5)

		"up":
			sword.rotation = -PI / 2
			sword.position = Vector2(5, 0)

func update_sword_draw_order():
	var sprite = anim

	match last_direction:
		"down":
			move_child(sword, get_child_count() - 1) # draw on top
		_:
			move_child(sword, 0) # draw behind
