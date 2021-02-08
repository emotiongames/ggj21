extends KinematicBody2D


enum EnemyState {IDLE, WALKING, SEEKING, PARALYZED}

export (NodePath) var nav_points
export (NodePath) var navigation_area
export (NodePath) var player
export (int) var speed = 80
export (float) var raycast_distance = 400
export (float) var raycast_facing_distance = 50
export (bool) var is_spawned = false

var raycast_direction = Vector2(raycast_distance, 0)
var facing_direction = Vector2(1, 0)
var nav_points_counter = 0
var enemy_state = EnemyState.IDLE
var instanced_nav_points = null
var instanced_navigation_area : Navigation2D
var instanced_player = null
var path : = PoolVector2Array()
var last_enemy_state = EnemyState.IDLE
var is_player_on_field_view = false
var damage_area
var is_on_damage_area = false

func _ready():
	instanced_player = get_node(player)
	#nav_points_counter = 7
	var _game_over_signal = Events.connect("game_over", self, "_on_Game_over")
	$RayCast2D.set_cast_to(raycast_direction)
	if instanced_nav_points == null:
		instanced_nav_points = get_node(nav_points).get_children()
		nav_points_counter = len(instanced_nav_points)
	add_to_group("enemy")
	if instanced_navigation_area == null:
		instanced_navigation_area = get_node(navigation_area)

func _physics_process(delta):
	if is_spawned:
		$RayCastFacingDirection.set_cast_to(facing_direction.normalized() * raycast_facing_distance)
		detect_raycast_collision()
		if is_on_damage_area:
			maybe_receive_damage()
		
		if enemy_state != EnemyState.PARALYZED:
			updated_player_position()
			if enemy_state != EnemyState.SEEKING:
				if enemy_state == EnemyState.IDLE and $Timers/IdleTimer.is_stopped():
					execute_idle_state()
				if enemy_state == EnemyState.WALKING:
					execute_walking_state(delta)
			else:
				execute_seeking_state(delta)


func maybe_receive_damage():
	if damage_area.active and damage_area.active_skill == "weak":
		if enemy_state != EnemyState.PARALYZED:
			last_enemy_state = enemy_state
			enemy_state = EnemyState.PARALYZED
			$Timers/StandstillTimer.start()


func detect_raycast_collision():
	if facing_direction.dot(raycast_direction) > 0.3:
		if $RayCast2D.is_colliding() and $RayCast2D.get_collider().is_in_group("player_raycast_detectable") and enemy_state != EnemyState.PARALYZED:
			is_player_on_field_view = true
			enemy_state = EnemyState.SEEKING
		else:
			is_player_on_field_view = false


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
		var distance_to_next_point = global_position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			facing_direction = global_position.direction_to(path[0])
			var velocity = facing_direction * distance_to_walk * speed
			move_and_slide(velocity)
		else:
			global_position = path[0]
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


func updated_player_position():
	raycast_direction = global_position.direction_to(instanced_player.global_position)
	$RayCast2D.set_cast_to(raycast_direction.normalized() * raycast_distance)
	
	if enemy_state == EnemyState.SEEKING:
		path = instanced_navigation_area.get_simple_path(self.global_position, instanced_player.global_position)


func follow_player(player_to_follow):
	instanced_player = player_to_follow


func _on_StandstillTimer_timeout():
	if last_enemy_state == EnemyState.SEEKING and not is_player_on_field_view:
		enemy_state = EnemyState.IDLE
		pass
	else:
		enemy_state = last_enemy_state


func _on_IdleTimer_timeout():
	choose_destination()
	enemy_state = EnemyState.WALKING


func set_navigation_area(node):
	instanced_navigation_area = node


func set_navigation_points(points):
	instanced_nav_points = points.get_children()
	nav_points_counter = len(instanced_nav_points)


func _on_Game_over():
	queue_free()


func _on_DamageArea_area_entered(area):
	if area.is_in_group("skill"):
		is_on_damage_area = true
		damage_area = area
		


func _on_DamageArea_area_exited(area):
	if area.is_in_group("skill"):
		is_on_damage_area = false
		damage_area = null
