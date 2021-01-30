extends KinematicBody2D


enum EnemyState {IDLE, WALKING, SEEKING, PARALYZED}

export (NodePath) var nav_points
export (NodePath) var navigation_area
export (int) var speed = 80
export (float) var raycast_distance = 256
export (float) var raycast_facing_distance = 50

var raycast_direction = Vector2(raycast_distance, 0)
var facing_direction = Vector2(1, 0)
var player_position : Vector2
var nav_points_counter = 0
var enemy_state = EnemyState.IDLE
var instanced_nav_points = []
var instanced_navigation_area : Navigation2D
var path : = PoolVector2Array()
var last_enemy_state = EnemyState.IDLE
var is_player_on_field_view = false

func _ready():
	var  _player_position_updated_signal = Events.connect("player_position_updated", self, "_on_Player_position_updated")
	var _is_enemy_paralyzed_signal = Events.connect("is_enemy_paralyzed", self, "_on_Is_enemy_paralyzed")
	$RayCast2D.set_cast_to(raycast_direction)
	instanced_nav_points = get_node(nav_points).get_children()
	nav_points_counter = len(instanced_nav_points)
	instanced_navigation_area = get_node(navigation_area)
	add_to_group("enemy")

func _physics_process(delta):
	$RayCastFacingDirection.set_cast_to(facing_direction.normalized() * raycast_facing_distance)
	detect_raycast_collision()
	
	if enemy_state != EnemyState.PARALYZED:
		if enemy_state != EnemyState.SEEKING:
			if enemy_state == EnemyState.IDLE and $Timers/IdleTimer.is_stopped():
				execute_idle_state()
			if enemy_state == EnemyState.WALKING:
				execute_walking_state(delta)
		else:
			execute_seeking_state(delta)

func detect_raycast_collision():
	if facing_direction.dot(raycast_direction) > 0.5:
		if $RayCast2D.is_colliding() and $RayCast2D.get_collider().is_in_group("player") and enemy_state != EnemyState.PARALYZED:
			is_player_on_field_view = true
			enemy_state = EnemyState.SEEKING
			#print("enemy sees player")
		else:
			#print("enemy sees obstacle")
			is_player_on_field_view = false
	#else:
		#print("no seeing player")


func execute_idle_state():
	$Timers/IdleTimer.wait_time = get_random_time_value()
	$Timers/IdleTimer.start()

func execute_walking_state(delta):
	# Walk to random points on navigation mesh
	move(delta)
	
	if len(path) == 0:
		enemy_state = EnemyState.IDLE


func execute_seeking_state(delta):
	move(delta)


func move(delta):
	var distance_to_walk = speed * delta

	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			facing_direction = global_position.direction_to(path[0])
			
			var velocity = facing_direction * distance_to_walk * speed
			move_and_slide(velocity)
		else:
			position = path[0]
			path.remove(0)
			
		distance_to_walk -= distance_to_next_point


func get_random_time_value():
	randomize()
	# random between 1 and 3
	return randi() % 4 + 1


func choose_destination():
	randomize()
	var destination = instanced_nav_points[randi() % nav_points_counter].global_position
	path = instanced_navigation_area.get_simple_path(self.global_position, destination)


func _on_Player_position_updated(player_global_position):
	player_position = player_global_position
	raycast_direction = global_position.direction_to(player_position)
	$RayCast2D.set_cast_to(raycast_direction.normalized() * raycast_distance)
	
	if enemy_state == EnemyState.SEEKING:
		path = instanced_navigation_area.get_simple_path(self.global_position, player_position)


func _on_Is_enemy_paralyzed():
	if enemy_state != EnemyState.PARALYZED:
		last_enemy_state = enemy_state
		enemy_state = EnemyState.PARALYZED
		$Timers/StandstillTimer.start()


func _on_StandstillTimer_timeout():
	if last_enemy_state == EnemyState.SEEKING and not is_player_on_field_view:
		enemy_state = EnemyState.IDLE
		pass
	else:
		enemy_state = last_enemy_state


func _on_IdleTimer_timeout():
	choose_destination()
	enemy_state = EnemyState.WALKING
