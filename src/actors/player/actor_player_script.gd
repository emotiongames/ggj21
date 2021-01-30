extends KinematicBody2D


const TIMER_DEFAULT = 0.08
const FLASH_SIMPLE_VALUE = 25
const FLASH_COMPLETE_VALUE = 100
const FLASH_ENERGY_DEFAULT = 0.8


enum SkillState {NO_SKILL, SIMPLE_SKILL, COMPLETE_SKILL}
enum FlashState {STATE_0, STATE_1, STATE_2, STATE_3}


export (int) var speed = 200
export (int) var set_skill_state = 0

var velocity = Vector2()
var view_direction = Vector2() #looking to down
var on_skill_area = false
var on_puzzle_item_area = false
var is_puzzle_item_on_flash_area = false
var available_skill = SkillState.NO_SKILL
var flash_state = FlashState.STATE_0
var last_flash_state = FlashState.STATE_0
var is_simple_flash_first_use = true
var is_complete_flash_first_use = true
var is_showing_skill_hint = false
var flash_gauge_value = 100
var pressed_time = 0
var puzzle_item
var enemies_on_flash_area = []
var flash_light_energy = FLASH_ENERGY_DEFAULT


func _ready():
	var _ui_flash_gauge_updated_signal = Events.connect("ui_flash_gauge_updated", self, "_on_Ui_flash_gauge_updated")
	add_to_group("player")
	
	available_skill = set_skill_state


func _process(delta):
	if not is_showing_skill_hint:
		view_movement()
	if on_skill_area or on_puzzle_item_area:
		get_interaction_input()
	if available_skill != SkillState.NO_SKILL:
		get_skill_input(delta)

func _physics_process(delta):
	if flash_state == FlashState.STATE_0 and not is_showing_skill_hint:
		move()


func view_movement():
	var view_direction = $ViewDirection.global_position.direction_to(get_global_mouse_position())
	var looking_to = get_look_direction(view_direction)
	$AnimatedSprite.animation = "walk_" + looking_to
	if flash_state == FlashState.STATE_0:
		$Flash.look_at(get_global_mouse_position())


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


func move():
	get_movement_input()
	velocity = move_and_slide(velocity)


func get_movement_input():
	velocity = Vector2()
	if Input.is_action_pressed('player_movement_right'):
		velocity.x += 1
	if Input.is_action_pressed('player_movement_left'):
		velocity.x -= 1
	if Input.is_action_pressed('player_movement_down'):
		velocity.y += 1
	if Input.is_action_pressed('player_movement_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	Events.emit_signal("player_position_updated", self.global_position)


func get_interaction_input():
	if Input.is_action_just_released('player_object_interaction'):
		if on_skill_area:
			Events.emit_signal("get_skill")
			is_showing_skill_hint = true
			if available_skill == SkillState.NO_SKILL:
				available_skill = SkillState.SIMPLE_SKILL
				$Light2D.enabled = true
				Events.emit_signal("ui_simple_skill_hint")
			elif available_skill == SkillState.SIMPLE_SKILL:
				available_skill = SkillState.COMPLETE_SKILL
				Events.emit_signal("ui_complete_skill_hint")
				Events.emit_signal("ui_set_flash_gauge_value", 100)
			on_skill_area = false
		if on_puzzle_item_area:
			if puzzle_item.is_flash_light_required():
				if puzzle_item.was_item_photographed():
					Events.emit_signal("get_puzzle_item", puzzle_item.get_item_name())
					$Inventory.set_actual_item(puzzle_item.get_item_name())
			else:
				Events.emit_signal("get_puzzle_item", puzzle_item.get_item_name())
				$Inventory.set_actual_item(puzzle_item.get_item_name())


func get_skill_input(delta):
	# mouse click
	if Input.is_action_pressed("player_skill_use"):
		pressed_time += delta
	if Input.is_action_just_released("player_skill_use") and pressed_time < 0.3:
		if available_skill == SkillState.SIMPLE_SKILL:
			if flash_gauge_value >= 25:
				do_skill_simple_action()
			if is_simple_flash_first_use:
				# Luzes se apagam
				# Som fica mais sombrio
				# Skill hint é oculta
				Events.emit_signal("ui_hide_skill_hint")
				is_simple_flash_first_use = false
				is_showing_skill_hint = false
		pressed_time = 0
	elif Input.is_action_just_released("player_skill_use"):
		if available_skill == SkillState.COMPLETE_SKILL:
			if flash_gauge_value >= 100:
				do_skill_complete_action()
			if is_complete_flash_first_use:
				# Inimigos começam a spawnar na arena
				Events.emit_signal("ui_hide_skill_hint")
				is_complete_flash_first_use = false
				is_showing_skill_hint = false
		pressed_time = 0


func do_skill_simple_action():
	Events.emit_signal("ui_update_flash_gauge", FLASH_SIMPLE_VALUE)
	flash_state = FlashState.STATE_1
	$Light2D.enabled = false
	$Flash/Light2D.enabled = true
	$Flash/Timer.start()
	if len(enemies_on_flash_area) > 0:
		for enemy in enemies_on_flash_area:
			Events.emit_signal("do_paralyze_enemy", enemy)


func do_skill_complete_action():
	Events.emit_signal("ui_update_flash_gauge", FLASH_COMPLETE_VALUE)
	flash_state = FlashState.STATE_1
	$Light2D.enabled = false
	$Flash/Light2D.enabled = true
	flash_light_energy = $Flash/Light2D.energy
	$Flash/Light2D.energy = flash_light_energy * 3
	$Flash/Timer.start()
	if len(enemies_on_flash_area) > 0:
		for enemy in enemies_on_flash_area:
			Events.emit_signal("do_damage_on_enemy", enemy)


func _on_InteractionArea_area_entered(area):
	if area.is_in_group("skill") and not on_skill_area:
		on_skill_area = true
	
	if area.is_in_group("puzzle_item") and not on_puzzle_item_area:
		on_puzzle_item_area = true
		puzzle_item = area


func _on_InteractionArea_area_exited(area):
	if area.is_in_group("skill") and on_skill_area:
		on_skill_area = false
		
	if area.is_in_group("puzzle_item") and on_puzzle_item_area:
		if area.is_flash_light_required():
			on_puzzle_item_area = false
			puzzle_item = null


func _on_Timer_timeout():
	match flash_state:
		FlashState.STATE_1:
			flash_state = FlashState.STATE_2
			$Flash/Light2D.enabled = false
			$Flash/Timer.wait_time = 0.1
			$Flash/Timer.start()
		FlashState.STATE_2:
			flash_state = FlashState.STATE_3
			$Flash/Light2D.enabled = true
			$Flash/Timer.wait_time = 0.27
			$Flash/Timer.start()
		FlashState.STATE_3:
			if puzzle_item:
				if puzzle_item.is_flash_light_required() and is_puzzle_item_on_flash_area:
					Events.emit_signal("puzzle_item_photographed", puzzle_item.get_item_name())
			flash_state = FlashState.STATE_0
			$Flash/Timer.wait_time = TIMER_DEFAULT
			$Light2D.enabled = true
			$Flash/Light2D.enabled = false
			if available_skill == SkillState.COMPLETE_SKILL:
				$Flash/Light2D.energy = flash_light_energy


func _on_FlashArea_body_exited(body):
	if body.is_in_group("enemy"):
		var index = enemies_on_flash_area.find(body)
		enemies_on_flash_area.remove(index)


func _on_FlashArea_body_entered(body):
	if body.is_in_group("enemy"):
		enemies_on_flash_area.append(body)


func _on_Ui_flash_gauge_updated(value):
	flash_gauge_value = value


func _on_FlashArea_area_entered(area):
	if area.is_in_group("puzzle_item"):
		is_puzzle_item_on_flash_area = true


func _on_FlashArea_area_exited(area):
	if area.is_in_group("puzzle_item"):
		is_puzzle_item_on_flash_area = false


func _on_EnemyInteractionArea_body_entered(body):
	if body.is_in_group("enemy"):
		print("enemy te matou")
		get_tree().reload_current_scene()
