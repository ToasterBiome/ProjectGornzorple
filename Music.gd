extends AudioStreamPlayer

var next_audio_stream = preload("res://sounds/BossMain.wav")

func _ready():
	await finished
	stream = next_audio_stream
	play()
