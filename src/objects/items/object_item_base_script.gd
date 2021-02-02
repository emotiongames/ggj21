extends Area2D

export (PackedScene) var scene_to_unlock


var type = ""


func _ready():
	add_to_group("item")


func do_action(_player):
	print("please overload this 'do_action' function")


func get_type():
	return type


func play_audio():
	if not $AudioItem.playing:
		$AudioItem.play()
