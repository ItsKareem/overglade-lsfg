extends Camera2D

@export var tilemap: TileMap

func _ready() -> void:
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_right = worldSizeInPixels.x -16
	limit_bottom = worldSizeInPixels.y -16
