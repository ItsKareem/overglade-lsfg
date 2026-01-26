extends CharacterBody2D

@export var patrol_speed = 20
@export var follow_speed = 30
@export var limit = 0.5
@export var patrol_right = 0
@export var patrol_down = 3
@export var follow_duration: int = 2
@export var knockbackPower := 600
@export var attack_cooldown := 1.5
@export var projectile_scene:= preload("res://bullet.tscn")

@onready var animations := $AnimatedSprite2D
@onready var damage_particles := $DamageParticles

var health: float = 6.0
var attack_range := 120
var startPosition
var endPosition
var moveDirection
var target: Player
var is_attacking := false
var can_attack := true
var current_direction := "down"

func _ready() -> void:
	add_to_group("projectiles")
	startPosition = position
	endPosition = startPosition + Vector2(patrol_right * 16, patrol_down * 16)

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	if is_attacking:
		velocity = Vector2.ZERO
		return
	
	if !target:
		moveDirection = (endPosition - position)
		if moveDirection.length() < limit:
			changeDirection()
		velocity = moveDirection.normalized() * patrol_speed
	else:
		moveDirection = (target.global_position - position)
		velocity = moveDirection.normalized() * follow_speed

func updateAnimation():
	if abs(moveDirection.x) > abs(moveDirection.y):
		if moveDirection.x > 0:
			current_direction = "right"
		else:
			current_direction = "left"
	else:
		if moveDirection.y > 0:
			current_direction = "down"
		else:
			current_direction = "up"
	animations.play("walk_" + current_direction)

func _physics_process(delta: float) -> void:
	if !is_attacking:
		updateVelocity()
		updateAnimation()
		try_attack()

	move_and_slide()



func _on_detect_player_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func _on_detect_player_body_exited(body: Node2D) -> void:
	if body == target:
		await get_tree().create_timer(2).timeout
		# Check again after waiting
		if target == body:
			target = null

func take_damage(weapon_damage: float):
	$Effects.play("take_damage")
	health -= weapon_damage
	
	if health <= 0.0:
		queue_free()

func knockback(direction: Vector2):
	var material = damage_particles.process_material
	material.direction =  Vector3(direction.x, direction.y, 0)
	damage_particles.global_position = global_position
	damage_particles.restart() 
	
	velocity = direction.normalized() * knockbackPower
	move_and_slide()

func try_attack():
	if !target or !can_attack:
		return

	if global_position.distance_to(target.global_position) <= attack_range:
		attack()

func attack():
	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO

	animations.play("attack_" + current_direction)

	shoot_projectile()

	await animations.animation_finished

	is_attacking = false

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func shoot_projectile():
	if projectile_scene == null:
		return

	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position

	var dir = (target.global_position - global_position).normalized()
	projectile.direction = dir

	get_parent().add_child(projectile)
