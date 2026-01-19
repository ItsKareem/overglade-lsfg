extends Camera2D

@export var tilemap: TileMap
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
