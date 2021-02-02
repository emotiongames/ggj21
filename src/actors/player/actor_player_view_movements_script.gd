extends Node2D


var player
var animation_player


func _ready():
	player = get_parent()
	animation_player = player.get_node("Animations")


func _process(delta):
	update_facing_direction()
	update_animation_direction()


func update_facing_direction():
	$FacingDirection.set_cast_to(get_local_mouse_position())


func update_animation_direction():
	var view_direction = $FacingDirection.get_cast_to().normalized()
	var looking_to = get_look_direction(view_direction)
	var movement_state = parse_player_state(player.movement_state)
	
	if animation_player.playing and movement_state != "walk":
		animation_player.stop()
	else:
		animation_player.animation = movement_state + "_" + looking_to
		animation_player.play()


func get_look_direction(direction):
	if (direction.x > -0.5 and direction.x < 0.5) and direction.y > 0:
		return "S"
	if (direction.x > -0.5 and direction.x < 0.5) and direction.y < 0:
		return "N"
	if direction.x > 0 and (direction.y > -0.5 and direction.y < 0.5):
		return "E"
	if direction.x < 0 and (direction.y > -0.5 and direction.y < 0.5):
		return "W"
	if direction.x > 0.5 and direction.y > 0:
		return "SE"
	if direction.x < -0.5 and direction.y > 0:
		return "SW"
	if direction.x > 0.5 and direction.y < 0:
		return "NE"
	if direction.x < -0.5 and direction.y < 0:
		return "NW"


func parse_player_state(state):
	match state:
		player.MovementState.IDLE:
			return "idle"
		player.MovementState.WALKING:
			return "walk"


func get_facing_direction():
	return $FacingDirection.get_cast_to()
