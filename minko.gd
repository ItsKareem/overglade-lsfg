extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var patrol_right = 4
@export var patrol_down = 0

@onready var animations := $AnimatedSprite2D

var startPosition
var endPosition
var moveDirection

func _ready() -> void:
	startPosition = position
	endPosition = startPosition + Vector2(patrol_right * 16, patrol_down * 16)

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
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
