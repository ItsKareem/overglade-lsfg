extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var patrol_right = 4
@export var patrol_down = 0

@onready var animations := $AnimatedSprite2D
@onready var player := $"../Player"

var health: float = 3.0
var startPosition
var endPosition
var moveDirection
var target: Player

func _ready() -> void:
	add_to_group("enemy")
	startPosition = position
	endPosition = startPosition + Vector2(patrol_right * 16, patrol_down * 16)

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	if !target:
		moveDirection = (endPosition - position)
		if moveDirection.length() < limit:
			changeDirection()
		velocity = moveDirection.normalized() * speed
	else:
		moveDirection = (target.global_position - position)
		velocity = moveDirection.normalized() * speed

func updateAnimation():
	if abs(moveDirection.x) > abs(moveDirection.y):
		if moveDirection.x > 0:
			animations.play("walk_right")
		else:
			animations.play("walk_left")
	else:
		if moveDirection.y > 0:
			animations.play("walk_down")
		else:
			animations.play("walk_up")

func _physics_process(delta: float) -> void:
	updateVelocity()
	updateAnimation()
	move_and_slide()

func take_damage(weapon_damage: float):
	$Effects.play("take_damage")
	target = player
	health -= weapon_damage
	if health <= 0.0:
		queue_free()
	if player == target:
		await get_tree().create_timer(6).timeout
		# Check again after waiting
		if target == player:
			target = null
