extends Area2D

enum SkillState {WEAK, STRONG}

var states_available = []


func _ready():
	add_to_group("skill")


func update_facing_direction(facing_position):
	print("please overload this 'update_facing_direction' function")


func play_effect(_skill_state):
	print("please overload this 'play_effect' function")


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
