extends "object_skill_base_script.gd"


const FLASH_ENERGY_DEFAULT = 1.0

func _ready():
	skill_name = "CameraFlash"
	.unlock_state(SkillState.WEAK)
	.set_weak_damage(25)
	.set_strong_damage(100)

func update_facing_direction(facing_position):
	if not $AnimationPlayer.is_playing():
		self.look_at(facing_position)

func play_effect(skill_state):
	if .is_available_skill_state(skill_state):
		match skill_state:
			SkillState.WEAK:
				$Flash.energy = FLASH_ENERGY_DEFAULT
				active_skill = "weak"
			SkillState.STRONG:
				$Flash.energy = FLASH_ENERGY_DEFAULT * 3
				active_skill = "strong"
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Flashing")
		if not $AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()
		active = true
		get_tree().paused = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Flashing":
		active = false
		active_skill = ""
		get_tree().paused = false
