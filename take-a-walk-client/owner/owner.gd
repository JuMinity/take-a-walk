extends Area2D

@export var speed = 100 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var target_position = Vector2.ZERO # 목표 지점 (마우스/터치 클릭 시)
var is_auto_moving = false # 자동 이동 중인지 여부
var last_direction = "south" # 마지막 방향 (idle 애니메이션용)

func _ready():
	screen_size = get_viewport_rect().size

func _input(event):
	# 마우스 클릭 또는 터치 이벤트 처리
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		target_position = event.position
		is_auto_moving = true
	elif event is InputEventScreenTouch and event.pressed:
		target_position = event.position
		is_auto_moving = true

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.

	# 키보드 입력 체크
	var has_keyboard_input = false
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		has_keyboard_input = true
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		has_keyboard_input = true
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		has_keyboard_input = true
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		has_keyboard_input = true

	# 키보드 입력이 있으면 자동 이동 취소
	if has_keyboard_input:
		is_auto_moving = false
		velocity = velocity.normalized() * speed
	# 자동 이동 중이면 목표 지점으로 이동
	elif is_auto_moving:
		var distance_to_target = position.distance_to(target_position)

		# 목표 지점에 충분히 가까우면 멈춤
		if distance_to_target > 5.0:
			var direction = (target_position - position).normalized()
			velocity = direction * speed
		else:
			is_auto_moving = false

	if velocity.length() > 0:
		# 이동 방향에 따라 애니메이션 선택
		var direction = "south"  # 기본값

		# 수평/수직 방향 중 더 큰 쪽으로 애니메이션 결정
		if abs(velocity.x) > abs(velocity.y):
			# 좌우 방향이 더 큼
			if velocity.x > 0:
				direction = "east"
			else:
				direction = "west"
		else:
			# 상하 방향이 더 큼
			if velocity.y > 0:
				direction = "south"
			else:
				direction = "north"

		# 마지막 방향 저장
		last_direction = direction
		var animation_name = "walking_" + direction

		# 현재 재생 중인 애니메이션과 다르면 변경
		if $AnimatedSprite2D.animation != animation_name:
			$AnimatedSprite2D.animation = animation_name

		$AnimatedSprite2D.play()
	else:
		# 멈춰있을 때 idle 애니메이션 재생
		var idle_animation = "idle_" + last_direction
		if $AnimatedSprite2D.animation != idle_animation:
			$AnimatedSprite2D.animation = idle_animation
			$AnimatedSprite2D.play()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
