extends Node

# 게임 전역 설정 관리
# 이 스크립트는 Autoload로 등록되어 어디서든 GameConfig로 접근 가능합니다.

# 맵 크기 (런타임에 동적으로 설정됨)
var MAP_WIDTH: int = 0
var MAP_HEIGHT: int = 0
var MAP_SIZE: Vector2 = Vector2.ZERO
var MAP_TILE_SIZE: int = 0

# 카메라 설정
const CAMERA_ZOOM_MOBILE = Vector2(2.0, 2.0)
const CAMERA_ZOOM_DESKTOP = Vector2(1.0, 1.0)

func _ready():
	print("=== Game Config Ready ===")
	print("Waiting for map to register its size...")

# 맵에서 호출하는 함수 - 맵 크기를 등록
func register_map_size(tile_map_layer: TileMapLayer):
	if tile_map_layer == null:
		print("ERROR: TileMapLayer is null!")
		return

	# TileSet에서 타일 크기 가져오기
	var tile_set = tile_map_layer.tile_set
	if tile_set:
		var tile_size_vec = tile_set.tile_size
		MAP_TILE_SIZE = tile_size_vec.x  # 정사각형 타일 가정

	# 실제 사용된 타일 영역 가져오기
	var used_rect = tile_map_layer.get_used_rect()

	# 픽셀 단위로 변환
	MAP_WIDTH = used_rect.size.x * MAP_TILE_SIZE
	MAP_HEIGHT = used_rect.size.y * MAP_TILE_SIZE
	MAP_SIZE = Vector2(MAP_WIDTH, MAP_HEIGHT)

	print("=== Map Size Registered ===")
	print("Used rect: ", used_rect)
	print("Tile size: ", MAP_TILE_SIZE, "px")
	print("Map size: ", MAP_WIDTH, "x", MAP_HEIGHT, " pixels")
	print("Map tiles: ", used_rect.size.x, "x", used_rect.size.y)
	print("===========================")
