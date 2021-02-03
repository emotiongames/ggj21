extends "object_base_event_script.gd"


func _ready():
	var node_audio_finished_signal = node.connect("finished", self, "on_Finished")


func play():
	node.play()


func is_playing():
	return node.playing


func on_Finished():
	emit_signal("is_done")
