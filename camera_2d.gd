extends Camera2D

@export var tilemap: TileMap
@onready var player = $"../Player"

const SCREEN_W := 256
const SCREEN_H := 176

var last_room : Vector2
var forced_limits := false

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
		update_camera_limits()
		snap_to_room()

func snap_to_room():
	global_position = Vector2(
		limit_left + SCREEN_W / 2,
		limit_top + SCREEN_H / 2
	)


#@export var smoothingVar = 5.0

#var actual_cam_pos : Vector2

#func _process(delta: float) -> void:
#	actual_cam_pos = actual_cam_pos.lerp($"../Player".global_position,delta * smoothingVar)
#	var cam_subpixel_offset = actual_cam_pos.round() - actual_cam_pos
#	get_parent().get_parent().get_parent().material.set_shader_parameter("cam_offset", cam_subpixel_offset)
#	global_position = actual_cam_pos.round()
#func _ready() -> void:
#	var mapRect = tilemap.get_used_rect()
#	var tileSize = tilemap.cell_quadrant_size
#	var worldSizeInPixels = mapRect.size * tileSize
#	limit_right = worldSizeInPixels.x -16
#	limit_bottom = worldSizeInPixels.y -16
