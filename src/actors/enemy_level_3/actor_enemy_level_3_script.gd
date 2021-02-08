extends KinematicBody2D


enum EnemyState {SEEKING, PARALYZED}


export (NodePath) var navigation_area
export (int) var speed = 80
export (float) var raycast_distance = 256
export (float) var raycast_facing_distance = 50

var raycast_direction = Vector2(raycast_distance, 0)
var facing_direction = Vector2(1, 0)
var player
var instanced_navigation_area
var enemy_state = EnemyState.SEEKING
var path : = PoolVector2Array()
var is_player_on_field_view = false
var damage_area
var instanced_spawn_point
var is_on_damage_area = false

func _ready():
	var _game_over_signal = Events.connect("game_over", self, "_on_Game_over")
	$RayCast2D.set_cast_to(raycast_direction)
	if instanced_navigation_area == null:
		instanced_navigation_area = get_node(navigation_area)
	add_to_group("enemy")
	$EnemySpawnCollisionArea.add_to_group("spawn_collision")


func _physics_process(delta):
	$RayCastFacingDirection.set_cast_to(facing_direction.normalized() * raycast_facing_distance)
	detect_raycast_collision()
	
	if is_on_damage_area:
		maybe_receive_damage()
	
	if enemy_state == EnemyState.SEEKING:
		updated_player_position()
		execute_seeking_state(delta)


func maybe_receive_damage():
	if damage_area.active:
		if damage_area.active_skill == "weak":
			if enemy_state != EnemyState.PARALYZED:
				enemy_state = EnemyState.PARALYZED
				$StandstillTimer.start()
		else:
			queue_free()


func updated_player_position():
	raycast_direction = global_position.direction_to(player.global_position)
	$RayCast2D.set_cast_to(raycast_direction.normalized() * raycast_distance)
	path = instanced_navigation_area.get_simple_path(self.global_position, player.global_position)


func follow_player(player_to_follow):
	player = player_to_follow


func detect_raycast_collision():
	if facing_direction.dot(raycast_direction) > 0.5:
		if $RayCast2D.is_colliding() and $RayCast2D.get_collider().is_in_group("player_raycast_detectable") and enemy_state != EnemyState.PARALYZED:
			is_player_on_field_view = true
			enemy_state = EnemyState.SEEKING
		else:
			is_player_on_field_view = false


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


func _on_StandstillTimer_timeout():
	enemy_state = EnemyState.SEEKING


func set_navigation_area(node):
	instanced_navigation_area = node



func set_spawn_point(spawn_point):
	instanced_spawn_point = spawn_point

func _on_EnemySpawnCollisionArea_area_entered(area):
	if area.is_in_group("spawn_collision"):
		instanced_spawn_point.hide()
		area.queue_free()


func _on_DamageArea_area_entered(area):
	if area.is_in_group("skill"):
		is_on_damage_area = true
		damage_area = area
		


func _on_DamageArea_area_exited(area):
	if area.is_in_group("skill"):
		is_on_damage_area = false
		damage_area = null


func _on_Game_over():
	queue_free()
