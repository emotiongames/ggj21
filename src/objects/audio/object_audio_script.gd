extends AudioStreamPlayer

export (String) var audio_name

func _ready():
	var audio_play_signal = Events.connect("audio_play", self, "_on_Audio_play")


func _on_Audio_play(name):
	if audio_name == name:
		if not self.playing:
			self.play()
