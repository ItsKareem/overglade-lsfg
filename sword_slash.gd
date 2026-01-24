extends Node2D

var player: Player
var hit_enemies := []

func _ready() -> void:
	if player == null:
		queue_free()
		return

	if !player.has_weapon("Hero Sword"):
		$Sprite2D/AnimationPlayer.play("slash")
	else:
		$Sprite2D/AnimationPlayer.play("moving_slash")


func _on_moving_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and player.has_weapon("Hero Sword") and !hit_enemies.has(body):
		hit_enemies.append(body)
		body.knockback(player.get_facing_vector())
		body.take_damage(1)
