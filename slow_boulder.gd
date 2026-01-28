extends CharacterBody2D

@export var speed := 60
var redirected := false
var boss: Node2D

func _ready():
	add_to_group("slow_boulder")
	boss = get_tree().get_first_node_in_group("boss")

func _physics_process(delta):
	if not redirected:
		velocity = Vector2.DOWN * speed
	else:
		velocity = (boss.global_position - global_position).normalized() * speed * 1.5
		
	move_and_slide()

func redirect_to_boss():
	if boss == null:
		return

	redirected = true

	var dir := (boss.global_position - global_position).normalized()
	velocity = dir * speed
