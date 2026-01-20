extends StaticBody2D

@export var item: Texture2D
@onready var animations = $AnimatedSprite2D
@onready var player = $"../Player"
@onready var item_start_pos: Vector2 = $StartMarker.position
@onready var item_end_pos: Vector2 = $EndMarker.position
var isOpen: bool = false

func _ready() -> void:
	animations.play("closed")

func interact(interactor: Node2D) -> void:
	if isOpen: return
	
	animations.play("open")
	isOpen = true
	spawn_and_collect(interactor)

func spawn_and_collect(interactor: Node2D) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = item
	sprite.position = item_start_pos
	add_child(sprite)
	
	var tween = create_tween()
	tween.tween_property(sprite, "position", item_end_pos, 0.3)
	await tween.finished
	sprite.queue_free()
	player.add_heart_container()
