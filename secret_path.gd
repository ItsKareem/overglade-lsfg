extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready() -> void:
	sprite.frame = 0
	collision.disabled = false

func destroy() -> void:
	sprite.frame = 1
	collision.set_deferred("disabled", true)
