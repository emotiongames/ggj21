extends CanvasLayer

#export (PackedScene) var game_over_screen
#export (PackedScene) var pause_menu_screen

var pause_screen

func _ready():
	var _game_over_signal = Events.connect("game_over", self, "_on_Game_over")
	var _pause_game_signal = Events.connect("pause_game", self, "_on_Pause_game")
	var _resume_game_signal = Events.connect("resume_game", self, "_on_Resume_game")


func _process(delta):
	if Input.is_action_pressed("ui_pause_game"):
		print('escape')
		get_tree().paused = true
		pause_screen = load("res://src/ui/screens/menus/pause/ui_screen_menu_pause.tscn").instance()
		add_child(pause_screen)

func _on_Game_over():
	get_tree().paused = true
	var game_over_screen = load("res://src/ui/screens/game_over/ui_screen_game_over.tscn").instance()
	add_child(game_over_screen)
