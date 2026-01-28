extends StaticBody2D

@export var end_scene: PackedScene

@onready var anim := $AnimatedSprite2D
@onready var collider := $Interact/CollisionShape2D

var isOpen := false

func interact(interactor: Node2D) -> void:
	if isOpen:
		return

	if not interactor.hasKey:
		return  # no key, do nothing (or play locked sound)

	interactor.use_key()
	unlock_door()

func unlock_door():
	anim.play("unlocking")
	await anim.animation_finished
	isOpen = true
	anim.play("opening")


func _on_interact_body_entered(body: Node2D) -> void:
	if isOpen and body is Player:
		get_tree().change_scene_to_packed(end_scene)


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "unlocking":
		collider.disabled = true
