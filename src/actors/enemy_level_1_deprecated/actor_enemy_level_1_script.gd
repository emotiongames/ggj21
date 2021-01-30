extends KinematicBody2D


enum MovementState {IDLE, WALKING, SEEKING, PARALYZED}


export (NodePath) var nav_points
export (NodePath) var navigation_area
export (int) var speed = 80
export (int) var detect_radius = 256

var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)
var target
var hit_pos

var is_spawnned = false
#var is_walking = false
var is_paralyzed = false
var is_player_on_view = false
var nav_points_counter = 0
var movement_state = MovementState.IDLE
var last_movement_state = MovementState.IDLE
var instanced_nav_points = []
var instanced_navigation_area : Navigation2D
var direction = Vector2()
var destination_point = Vector2()
var choosed_destination = Vector2()
var path : = PoolVector2Array()


func _ready():
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Area2D/CollisionShape2D.shape = shape
	
	var _is_enemy_paralyzed_signal = Events.connect("is_enemy_paralyzed", self, "_on_Is_enemy_paralyzed")
	
	is_spawnned = true
	
	instanced_nav_points = get_node(nav_points).get_children()
	nav_points_counter = len(instanced_nav_points)
	instanced_navigation_area = get_node(navigation_area)
	do_idle_movement()
	add_to_group("enemy")


func _physics_process(delta):
	update()
	
	if is_spawnned and movement_state != MovementState.PARALYZED:
		if target:
			aim()
		#move(delta)

func _draw():
	# display the visibility area
	draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		draw_circle((hit_pos - position).rotated(-rotation), 5, laser_color)
		draw_line(Vector2(), (hit_pos - position).rotated(-rotation), laser_color)

func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position,
					[self], collision_mask)
	if result:
		hit_pos = result.position
		print(result.collider.name)
	pass


func move(delta):
	if movement_state == MovementState.IDLE and $Timers/IdleTimer.is_stopped():
		do_idle_movement()
	elif movement_state == MovementState.WALKING:
		do_walking_movement(delta)
	elif movement_state == MovementState.SEEKING:
		do_seeking_movement(delta)


func do_idle_movement():
	# Stay stopped for some seconds then walk or seek when player is on field
	$Timers/IdleTimer.wait_time = get_random_time_value()
	$Timers/IdleTimer.start()


func do_walking_movement(delta):
	# Walk to random points on navigation mesh
	var distance_to_walk = speed * delta

	# Move the enemy along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The enemy  does not have enough movement left to get to the next point.
			direction = global_position.direction_to(path[0])
			
			var velocity = direction * distance_to_walk * speed
			move_and_slide(velocity)
		else:
			# The enemy  get to the next point
			position = path[0]
			path.remove(0)
			
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point
	if len(path) == 0:
		movement_state = MovementState.IDLE
			#is_walking = false


func look_to_destination(point):
	#var space_state = get_world_2d().direct_space_state
	direction = global_position.direction_to(point)
	#var result = space_state.intersect_ray(self.global_position, direction * Vector2(256.0, 256.0), [self])
	#print(result)
	#$RayCast2D.set_cast_to(direction * Vector2(256.0, 256.0))


func do_seeking_movement(delta):
	# Seek the player if it on your view field
	pass


func get_random_destination_point():
	randomize()
	return instanced_nav_points[randi() % nav_points_counter].global_position


func get_random_time_value():
	randomize()
	# random between 1 and 3
	return randi() % 4 + 1 


func _on_IdleTimer_timeout():
	choosed_destination = get_random_destination_point()
	set_destination(choosed_destination)
	


func set_destination(destination):
	path = instanced_navigation_area.get_simple_path(self.position, destination)
	movement_state = MovementState.WALKING
	#is_walking = true


func _on_Is_enemy_paralyzed():
	last_movement_state = movement_state
	movement_state = MovementState.PARALYZED
	$Timers/StandstillTimer.start()


func _on_StandstillTimer_timeout():
	movement_state = last_movement_state


func _on_Area2D_body_entered(body):
	if target:
		return
	target = body
	#print(target)
#	if body.is_in_group("player"):
#		print("player_entrou")
#		is_player_on_view = true
#		print(body.global_position)
#		look_to_destination(body.global_position)
#		print($RayCast2D.get_collider())
#		print(body)
		#if $RayCast2D.get_co:
#			# inicia perseguição
			#print("to te vendo player")
#			start_player_seeking(body)
#		else:
#			look_to_destination(path[0])


func start_player_seeking(player):
	movement_state = MovementState.SEEKING
	set_destination(player.global_position)


func _on_Area2D_body_exited(body):
	if body == target:
		target = null
#	if body.is_in_group("player"):
#		print("player_saiu")
#		is_player_on_view = false
