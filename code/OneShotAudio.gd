extends AudioStreamPlayer3D

func _ready():
	await finished
	queue_free()
