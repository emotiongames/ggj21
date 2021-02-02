extends "object_skill_base_script.gd"


const FLASH_ENERGY_DEFAULT = 1.0

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	.unlock_state(SkillState.WEAK)

func update_facing_direction(facing_position):
	if not $AnimationPlayer.is_playing():
		self.look_at(facing_position)

func play_effect(skill_state):
	if .is_available_skill_state(skill_state):
		get_tree().paused = true
		match skill_state:
			SkillState.WEAK:
				$Flash.energy = FLASH_ENERGY_DEFAULT
			SkillState.STRONG:
				$Flash.energy = FLASH_ENERGY_DEFAULT * 3
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Flashing")
		if not $AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Flashing":
		get_tree().paused = false
