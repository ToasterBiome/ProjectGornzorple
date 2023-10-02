extends Control

@onready var play_button: Button = $"Play Button"
@onready var credits_button: Button = $"Credits Button"
@onready var exit_button: Button = $"Exit Button"
@onready var best_score_text: RichTextLabel = $"Best Score Text"

func _ready():
	play_button.pressed.connect(func(): get_tree().change_scene_to_file("res://3dscene.tscn"))
	exit_button.pressed.connect(func(): get_tree().quit())
	best_score_text.text = "Score: %s" % str(Globals.best_score)
