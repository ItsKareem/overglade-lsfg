extends CharacterBody2D

@export var patrol_speed = 20
@export var follow_speed = 30
@export var limit = 0.5
@export var patrol_right = 4
@export var patrol_down = 0
@export var follow_duration: int = 2

@onready var animations := $AnimatedSprite2D

var startPosition
var endPosition
var moveDirection
var target: Player

func _ready() -> void:
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
		velocity = moveDirection.normalized() * patrol_speed
	else:
		moveDirection = (target.global_position - position)
		velocity = moveDirection.normalized() * follow_speed

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


func _on_detect_player_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func _on_detect_player_body_exited(body: Node2D) -> void:
	if body == target:
		await get_tree().create_timer(2).timeout
		# Check again after waiting
		if target == body:
			target = null
