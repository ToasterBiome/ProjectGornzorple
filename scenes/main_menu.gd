extends Control

@onready var play_button: Button = $"VBoxContainer/Play Button"
@onready var play_skip_button: Button = $"VBoxContainer/Play (Skip) Button"
@onready var credits_button: Button = $"VBoxContainer/Credits Button"
@onready var exit_button: Button = $"VBoxContainer/Exit Button"
@onready var best_score_text: RichTextLabel = $"Best Score Text"

@onready var music_volume = $VBoxContainer/HBoxContainer/Music
@onready var sfx_volume = $VBoxContainer/HBoxContainer2/SFX

@onready var credits_window = $Credits

var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

@onready var splash_screen = $Splash

func _ready():
	play_button.pressed.connect(func(): 
		Globals.skip_cutscene = false
		get_tree().change_scene_to_file("res://3dscene.tscn")
		)
	play_skip_button.pressed.connect(func(): 
		Globals.skip_cutscene = true
		get_tree().change_scene_to_file("res://3dscene.tscn")
		)
	credits_button.pressed.connect(func():
		credits_window.show()
		)
	music_volume.value_changed.connect(func(value):
		AudioServer.set_bus_volume_db(music_bus, value)
		if(value <= -30):
			AudioServer.set_bus_mute(music_bus, true)
		else:
			AudioServer.set_bus_mute(music_bus, false)
		)
	sfx_volume.value_changed.connect(func(value):
		AudioServer.set_bus_volume_db(sfx_bus, value)
		if(value <= -30):
			AudioServer.set_bus_mute(sfx_bus, true)
		else:
			AudioServer.set_bus_mute(music_bus, false)
		)
	
	exit_button.pressed.connect(func(): get_tree().quit())
	best_score_text.text = "Score: %s" % str(Globals.best_score)
	
	splash_screen.modulate = Color.WHITE
	await get_tree().create_timer(3.0).timeout
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(splash_screen,"modulate",Color(0,0,0,0),1.0)
	await get_tree().create_timer(1.0).timeout
	splash_screen.mouse_filter = MOUSE_FILTER_IGNORE
