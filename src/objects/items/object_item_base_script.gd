extends Area2D

export (PackedScene) var scene_to_unlock
export (NodePath) var skill_hint_player
export (bool) var is_puzzle_item = false
export (bool) var is_locked = false


var type = ""
var is_player_close = false
var on_skill_area = false
var skill
var skill_hint


func _ready():
	if skill_hint_player:
		skill_hint = get_node(skill_hint_player)
	pause_mode = Node.PAUSE_MODE_PROCESS
	if is_puzzle_item:
		add_to_group("puzzle_item")
	else:
		add_to_group("item")


func do_action(_player):
	print("please overload this 'do_action' function")


func get_type():
	return type


func play_audio(audio):
	if not audio.playing:
		audio.play()
