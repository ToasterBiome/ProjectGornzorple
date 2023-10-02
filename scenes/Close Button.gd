extends Button

@onready var window = $".."

func _ready():
	pressed.connect(func():
		window.hide()
		)
