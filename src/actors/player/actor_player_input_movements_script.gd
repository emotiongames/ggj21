extends Node2D


var player
var view_movement
var velocity = Vector2()


func _ready():
	player = get_parent()
	view_movement = player.get_node("ViewMovements")


func _physics_process(delta):
	move()


func move():
	velocity = get_movement_velocity()
	if velocity != Vector2():
		if not $Footsteps.playing:
			$Footsteps.play()
	player.move_and_slide(velocity)

func get_movement_velocity():
	velocity = Vector2()
	if Input.is_action_pressed('player_movement_up'):
		velocity = view_movement.get_facing_direction()
	return velocity.normalized() * player.speed


func get_movement_state():
	if velocity != Vector2():
		return player.MovementState.WALKING
	else:
		return player.MovementState.IDLE
