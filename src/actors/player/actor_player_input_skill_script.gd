extends Node2D

enum SkillState {WEAK, STRONG}


var pressed_time = 0
var selected_skill : String = "CameraFlash"
var view_movements
var flash_hud


func _ready():
	var player = get_parent()
	view_movements = player.get_node("ViewMovements")
	flash_hud = player.get_node(player.flash_hud)

func _process(delta):
	PlayerSkills.global_position = get_parent().global_position
	if PlayerSkills.get_child_count() > 0:
		if selected_skill != "" and PlayerSkills.get_node(selected_skill):
			use_skill(delta)

func use_skill(delta):
	var skill = PlayerSkills.get_node(selected_skill)
	skill.update_facing_direction(get_global_mouse_position())
	if Input.is_action_pressed("player_skill_use"):
		pressed_time += delta
	if Input.is_action_just_released("player_skill_use") and pressed_time < 0.3:
		if flash_hud.can_reduce_gauge(skill.damage_value(SkillState.WEAK)):
			skill.play_effect(SkillState.WEAK)
			pressed_time = 0
	elif Input.is_action_just_released("player_skill_use") and skill.is_available_skill_state(SkillState.STRONG):
		if flash_hud.can_reduce_gauge(skill.damage_value(SkillState.STRONG)):
			skill.play_effect(SkillState.STRONG)
			pressed_time = 0
	elif Input.is_action_just_released("player_skill_use"):
		pressed_time = 0


func set_skill(skill_name):
	selected_skill = skill_name
