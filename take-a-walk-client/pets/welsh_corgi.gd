extends Area2D

@export var speed = 100 # 강아지 이동 속도
@export var follow_radius = 300 # 주인으로부터 떨어질 수 있는 최대 거리
@export var wander_range = 300 # 배회할 범위 (follow_radius보다 작아야 함)
@export var min_distance = 80 # 주인과의 최소 거리 (겹침 방지)

var screen_size
var target_position = Vector2.ZERO # 목표 지점
var move_timer = 0.0 # 새로운 목표 지점을 생성할 타이머
var change_target_time = 2.0 # 목표 지점 변경 주기 (초)
var last_direction = Vector2.DOWN # 마지막으로 향했던 방향 (애니메이션용)
var is_moving = false # 현재 움직이는 중인지

func _ready():
	screen_size = get_viewport_rect().size
	# 초기 목표 위치 설정
	target_position = position

func _process(delta):
	# 형제 노드인 Owner를 참조
	var owner_node = get_parent().get_node("Owner")

	# 타이머 업데이트
	move_timer += delta

	# 주인과의 거리 체크
	var distance_to_owner = position.distance_to(owner_node.position)

	# 목표 지점에 가까워졌거나, 시간이 지났거나, 주인이 너무 멀리 가면 새 목표 생성
	if move_timer >= change_target_time or distance_to_owner > follow_radius:
		target_position = get_random_position_around_owner(owner_node.position)
		move_timer = 0.0

	# 목표 지점으로 이동 (owner를 피하면서)
	var distance_to_target = position.distance_to(target_position)

	# 목표 지점에 충분히 가까우면 멈춤 (떨림 방지)
	if distance_to_target > 5.0:
		var direction = (target_position - position).normalized()
		
		position += direction * speed * delta
		last_direction = direction
		is_moving = true
	else:
		is_moving = false

	position = position.clamp(Vector2.ZERO, screen_size)

	# 애니메이션 업데이트
	update_animation()

	# 목줄 그리기
	update_leash(owner_node)

# 주인 주변의 랜덤한 위치 반환
func get_random_position_around_owner(owner_pos: Vector2) -> Vector2:
	# 원 안의 랜덤한 각도
	var angle = randf() * TAU  # TAU = 2 * PI
	# min_distance부터 wander_range 사이의 랜덤한 거리 (겹침 방지)
	var distance = min_distance + randf() * (wander_range - min_distance)

	# 극좌표를 직교좌표로 변환
	var offset = Vector2(cos(angle), sin(angle)) * distance

	return owner_pos + offset

# 애니메이션 업데이트
func update_animation():
	var animated_sprite = $AnimatedSprite2D

	# 방향 결정 (4방향: up, down, left, right)
	var anim_direction = ""

	# 수평/수직 중 어느 쪽이 더 강한지 판단
	if abs(last_direction.x) > abs(last_direction.y):
		# 수평 방향이 더 강함
		if last_direction.x > 0:
			# 오른쪽: 왼쪽 애니메이션을 flip해서 사용
			anim_direction = "left"
			animated_sprite.flip_h = true
		else:
			anim_direction = "left"
			animated_sprite.flip_h = false
	else:
		# 수직 방향이 더 강함
		if last_direction.y > 0:
			anim_direction = "down"
		else:
			anim_direction = "up"
		animated_sprite.flip_h = false

	# 움직임 상태에 따라 애니메이션 선택
	var anim_name = ""
	if is_moving:
		anim_name = "walk_" + anim_direction
	else:
		anim_name = "idle_" + anim_direction

	# 애니메이션 재생
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)

# 목줄 업데이트
func update_leash(owner_node):
	var leash = $Leash

	# Line2D는 WelshCorgi의 자식이므로 로컬 좌표계 사용
	# 강아지 위치는 (0, 0)
	# 주인 위치는 global_position을 기준으로 상대 위치 계산
	var owner_local_pos = owner_node.global_position - global_position

	# 목줄의 시작점(주인)과 끝점(강아지) 설정
	leash.points = [owner_local_pos, Vector2.ZERO]
