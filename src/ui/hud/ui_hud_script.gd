extends Control


export (bool) var show_flash_hud = false


func _ready():
	if show_flash_hud:
		$FlashHUD.show()
