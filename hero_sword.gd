extends StaticBody2D

@export var item: Texture2D
@onready var sprite = $HeroSwordInStone
@onready var player = $"../Player"

func _ready() -> void:
	sprite.frame = 0
	$HeroSwordInStone/PointLight2D.visible = true

func interact(interactor: Node2D) -> void:
	if player.unlocked_weapons["Hero Sword"] == true : return
	sprite.frame = 1
	$HeroSwordInStone/PointLight2D.visible = false
	player.unlocked_weapons["Hero Sword"] = true
