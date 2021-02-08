extends KinematicBody2D


enum MovementState {IDLE, WALKING}


export (float) var speed = 400.0
export (PackedScene) var set_skill
export (NodePath) var flash_hud
export (bool) var is_with_camera = false
export (String) var skill_name

var movement_state = MovementState.IDLE


func _ready():
	if PlayerSkills.get_child_count() == 0 and set_skill:
		PlayerSkills.add_child(set_skill.instance())
		$InputSkill.set_skill(skill_name)
	if is_with_camera:
		$LightBehavior.play("turn_on")
	add_to_group("player")
	$EnemyCollisionArea.add_to_group("player_raycast_detectable")


func _physics_process(delta):
	update_movement_state()


func update_movement_state():
	movement_state = $InputMovements.get_movement_state()


func _on_EnemyCollisionArea_body_entered(body):
	print("enemy te matou")
	Events.emit_signal("game_over")
	self.hide()
