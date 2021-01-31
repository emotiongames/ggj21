extends KinematicBody2D


enum EnemyState {SEEKING, PARALYZED}


export (NodePath) var navigation_area
export (int) var speed = 80
export (float) var raycast_distance = 256
export (float) var raycast_facing_distance = 50

var raycast_direction = Vector2(raycast_distance, 0)
var facing_direction = Vector2(1, 0)
var player_position : Vector2
var instanced_navigation_area
var enemy_state = EnemyState.SEEKING
var path : = PoolVector2Array()
var is_player_on_field_view = false


func _ready():
	var  _player_position_updated_signal = Events.connect("player_position_updated", self, "_on_Player_position_updated")
	var _do_paralyze_enemy_signal = Events.connect("do_paralyze_enemy", self, "_on_Do_paralyze_enemy")
	var _do_damage_on_enemy_signal = Events.connect("do_damage_on_enemy", self, "_on_Do_damage_on_enemy")
	$RayCast2D.set_cast_to(raycast_direction)
	if instanced_navigation_area == null:
		instanced_navigation_area = get_node(navigation_area)
	add_to_group("enemy")
	$EnemySpawnCollisionArea.add_to_group("spawn_collision")


func _physics_process(delta):
	$RayCastFacingDirection.set_cast_to(facing_direction.normalized() * raycast_facing_distance)
	detect_raycast_collision()
	
	if enemy_state == EnemyState.SEEKING:
		execute_seeking_state(delta)


func detect_raycast_collision():
	if facing_direction.dot(raycast_direction) > 0.5:
		if $RayCast2D.is_colliding() and $RayCast2D.get_collider().is_in_group("player") and enemy_state != EnemyState.PARALYZED:
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


func _on_Player_position_updated(player_global_position):
	player_position = player_global_position
	raycast_direction = global_position.direction_to(player_position)
	$RayCast2D.set_cast_to(raycast_direction.normalized() * raycast_distance)
	
	if enemy_state == EnemyState.SEEKING:
		path = instanced_navigation_area.get_simple_path(self.global_position, player_position)


func _on_Do_paralyze_enemy(enemy):
	if self == enemy:
		if enemy_state != EnemyState.PARALYZED:
			enemy_state = EnemyState.PARALYZED
			$StandstillTimer.start()


func _on_StandstillTimer_timeout():
	enemy_state = EnemyState.SEEKING


func _on_Do_damage_on_enemy(enemy):
	if self == enemy:
		queue_free()


func set_navigation_area(node):
	instanced_navigation_area = node


func _on_EnemySpawnCollisionArea_area_entered(area):
	if area.is_in_group("spawn_collision"):
		print("collision detected")
		queue_free()
	#pass # Replace with function body.
