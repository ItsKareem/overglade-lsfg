extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var player = $"../Player"

func _ready() -> void:
	sprite.frame = 0
	collision.disabled = false

func destroy() -> void:
	if player.has_weapon("Hero Sword"):
		sprite.frame = 1
		collision.set_deferred("disabled", true)
