extends KinematicBody2D


enum MovementState {IDLE, WALKING}


export (float) var speed = 400.0

var movement_state = MovementState.IDLE


func _ready():
	add_to_group("player")


func _physics_process(delta):
	update_movement_state()


func update_movement_state():
	movement_state = $InputMovements.get_movement_state()


func _on_EnemyCollisionArea_body_entered(body):
	print("enemy te matou")
	queue_free()
