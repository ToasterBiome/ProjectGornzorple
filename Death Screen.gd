extends ColorRect

@onready var back_button: Button = $"Main Menu Button"
@onready var score_text: RichTextLabel = $Score

func _ready():
	back_button.pressed.connect(Callable(self, "_go_to_main_menu"))

func update():
	score_text.text = ""
	score_text.append_text("[center]Score: %s" % str(Globals.score))

func _go_to_main_menu():
	Globals.best_score = Globals.score
	Globals.score = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
