extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
