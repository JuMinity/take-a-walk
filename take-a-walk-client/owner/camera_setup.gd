extends Camera2D

func _ready():
	# 맵 크기 설정 (GameConfig에서 가져옴)
	limit_left = 0
	limit_top = 0
	limit_right = GameConfig.MAP_WIDTH
	limit_bottom = GameConfig.MAP_HEIGHT

	# 플랫폼에 따라 카메라 줌 자동 조정
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		# 모바일: 확대해서 보기
		zoom = GameConfig.CAMERA_ZOOM_MOBILE
		print("Mobile detected - zoom set to ", zoom)
	else:
		# PC/Desktop: 넓은 시야
		zoom = GameConfig.CAMERA_ZOOM_DESKTOP
		print("Desktop detected - zoom set to ", zoom)

	print("Camera limits set to map size: ", limit_right, "x", limit_bottom)
