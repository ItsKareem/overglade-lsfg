extends Camera2D

@export var tilemap: TileMap
@onready var player = $"../Player"

const SCREEN_W := 256
const SCREEN_H := 176

var last_room : Vector2
var forced_limits := false
var follow_player := false

func update_camera_limits():
	if forced_limits:
		return

	var room := Vector2(
		floor(player.global_position.x / SCREEN_W),
		floor(player.global_position.y / SCREEN_H)
	)

	var left   := room.x * SCREEN_W
	var top    := room.y * SCREEN_H
	var right  := left + SCREEN_W
	var bottom := top + SCREEN_H

	limit_left   = left
	limit_top    = top
	limit_right  = right
	limit_bottom = bottom

func _process(delta):

	var current_room = Vector2(
		floor(player.global_position.x / SCREEN_W),
		floor(player.global_position.y / SCREEN_H)
	)

	if current_room != last_room:
		last_room = current_room
		if !follow_player:
			update_camera_limits()
			snap_to_room()

	if follow_player:
		global_position = player.global_position

func snap_to_room():
	global_position = Vector2(
		limit_left + SCREEN_W / 2,
		limit_top + SCREEN_H / 2
	)

func _on_boss_room_camera_body_entered(body: Node2D) -> void:
	if body != player:
		return

	forced_limits = true
	follow_player = true

	limit_left   = 1280
	limit_top    = 176
	limit_right  = 1792
	limit_bottom = 352



func _on_boss_room_camera_body_exited(body: Node2D) -> void:
	if body != player:
		return

	forced_limits = false
	follow_player = false

	last_room = Vector2(-1, -1)
	update_camera_limits()
	snap_to_room()
