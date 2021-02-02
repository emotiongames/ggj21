extends Node2D

enum SkillState {WEAK, STRONG}


var pressed_time = 0
var selected_skill = -1
var skills_node
var view_movements


func _ready():
	var player = get_parent()
	skills_node = player.get_node("Skills")
	view_movements = player.get_node("ViewMovements")

func _process(delta):
	if selected_skill > -1 and skills_node.get_child_count() > 0:
		use_skill(delta)

func use_skill(delta):
	var skill = skills_node.get_children()[selected_skill]
	skill.update_facing_direction(get_global_mouse_position())
	if Input.is_action_pressed("player_skill_use"):
		pressed_time += delta
	if Input.is_action_just_released("player_skill_use") and pressed_time < 0.3:
		skill.play_effect(SkillState.WEAK)
		pressed_time = 0
	elif Input.is_action_just_released("player_skill_use"):
		skill.play_effect(SkillState.STRONG)
		pressed_time = 0


func set_skill(idx):
	selected_skill = idx
