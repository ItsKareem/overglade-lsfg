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

	
	if Input.is_action_pressed("attack") and canSlash:
		$sword/AnimationPlayer.speed_scale = $sword/AnimationPlayer.get_animation("slash").length / slash_time
		$sword/AnimationPlayer.play("slash")
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
	if anim_name == "slash":
		$sword/AnimationPlayer.speed_scale = $sword/AnimationPlayer.get_animation("slash").length / sword_return_time
		$sword/AnimationPlayer.play("sword_return")
	else:
		canSlash = true
		is_attacking = false

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


#func spawn_slash():
#	var slash = sword_slash_preload.instantiate()

#	var dir := get_facing_vector()
#	var distance := 12

#	slash.position = (dir * distance).round()
#	slash.rotation = dir.angle() + PI / 2
#	slash.weapon_damage = weapon_damage

#	# Flip if needed
#	if dir == Vector2.LEFT:
#	else:
#		slash.get_node("Sprite2D").flip_v = false

#	get_parent().add_child(slash)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(weapon_damage)

func start_attack():
	canSlash = false
	is_attacking = true
	velocity = Vector2.ZERO
	anim.play("attack_" + last_direction)
