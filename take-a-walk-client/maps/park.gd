extends Node2D

func _ready():
	# TileMapLayer를 찾아서 맵 크기를 GameConfig에 등록
	var tile_map = $TileMapLayer
	if tile_map:
		GameConfig.register_map_size(tile_map)
	else:
		print("ERROR: TileMapLayer not found in park scene!")
