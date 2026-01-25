extends StaticBody2D

@onready var anim := $AnimatedSprite2D
@onready var collision := $CollisionShape2D

func _ready() -> void:
	anim.visible = false
	collision.disabled = true

func enter():
	collision.set_deferred("disabled", false)
	anim.visible = true
	anim.play("enter")

func exit():
	anim.play("exit")
	await anim.animation_finished
	anim.visible = false
	collision.set_deferred("disabled", true)
