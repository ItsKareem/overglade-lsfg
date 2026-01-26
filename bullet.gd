extends CharacterBody2D

@export var speed := 120.0
@export var damage := 1

var direction: Vector2 = Vector2.ZERO

func _ready():
	# Safety check
	if direction == Vector2.ZERO:
		queue_free()

func _physics_process(delta):
	position += direction * speed * delta


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hurtByEnemy(self)
	queue_free()
