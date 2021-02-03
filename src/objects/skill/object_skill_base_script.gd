extends Area2D

enum SkillState {WEAK, STRONG}

var states_available = []
var active = false
var active_skill = ""
var skill_name = ""
var weak_damage = 0
var strong_damage = 0


func _ready():
	add_to_group("skill")


func update_facing_direction(facing_position):
	print("please overload this 'update_facing_direction' function")


func play_effect(_skill_state):
	print("please overload this 'play_effect' function")


func set_weak_damage(value):
	weak_damage = value


func set_strong_damage(value):
	strong_damage = value


func damage_value(skill_state):
	match skill_state:
		SkillState.WEAK:
			return weak_damage
		SkillState.STRONG:
			return strong_damage


func unlock_state(new_skill_state):
	match new_skill_state:
		SkillState.WEAK:
			states_available.append("weak")
		SkillState.STRONG:
			states_available.append("strong")


func get_available_states():
	return states_available


func is_available_skill_state(skill_state):
	match skill_state:
		SkillState.WEAK:
			return "weak" in states_available
		SkillState.STRONG:
			return "strong" in states_available


func get_skill_name():
	return skill_name
