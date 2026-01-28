extends CharacterBody2D

enum State {
	SLEEPING,
	WAKING,
	WALK,
	THROW_ROCK,
	ARENA_ATTACK,
	VULNERABLE,
	DEAD
}

@export var fast_boulder_scene: PackedScene
@export var slow_boulder_scene: PackedScene
@export var max_health := 100
var health := max_health
var current_state : State = State.SLEEPING

@onready var anim := $AnimatedSprite2D
@onready var state_timer := $StateTimer
@onready var attack_timer := $AttackTimer
@onready var player := $"../Player"
@onready var hitbox := $hitbox

func _ready():
	set_state(State.SLEEPING)

func set_state(new_state: State):
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match new_state:
		State.SLEEPING:
			anim.play("inactive")
		State.WAKING:
			anim.play("aware")
		State.WALK:
			anim.play("walk")
			attack_timer.start(1.5)
		State.THROW_ROCK:
			anim.play("attack")
		State.ARENA_ATTACK:
			anim.play("attack")
#			start_arena_attack()
		State.VULNERABLE:
			anim.play("vulnerable")
			state_timer.start(4.0)
		State.DEAD:
			anim.play("death")
			hitbox.monitoring = false
			hitbox.monitorable = false

#func _on_AttackTimer_timeout():
	#if current_state != State.WALK:
	#	return
		
	#if randi() % 2 == 0:
	#	set_state(State.THROW_ROCK)
	#else:
	#	set_state(State.ARENA_ATTACK)

#func throw_boulder():
	#var scene := fast_boulder_scene if randi() % 3 < 2 else slow_boulder_scene
	#var boulder = scene.instantiate()

	#boulder.global_position = global_position
	#boulder.direction = (player.global_position - global_position).normalized()
	#get_parent().add_child(boulder)

	#set_state(State.WALK)

#func _on_hitbox_body_entered(body: Node2D) -> void:
	#if body.is_in_group("slow_boulder"):
	#	body.queue_free()
	#	set_state(State.VULNERABLE)


#func _on_animated_sprite_2d_animation_finished() -> void:
#	if anim.animation == "attack":
#		throw_boulder()
#	elif anim.animation == "aware":
	#	set_state(State.WALK)
