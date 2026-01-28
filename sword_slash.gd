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
	if player.has_weapon("Hero Sword"):
		if body.is_in_group("enemy") and !hit_enemies.has(body):
			hit_enemies.append(body)
			if body.has_method("knockback"):
				body.knockback(player.get_facing_vector(player.attack_direction))
			if body.has_method("take_damage"):
				body.take_damage(player.weapon_damage)
		if body.has_method("destroy"):
			body.destroy()
		if body.has_method("redirect_to_boss"):
			body.redirect_to_boss()
