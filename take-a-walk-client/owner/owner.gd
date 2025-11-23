extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var target_position = Vector2.ZERO # 목표 지점 (마우스/터치 클릭 시)
var is_auto_moving = false # 자동 이동 중인지 여부

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
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
