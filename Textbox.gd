extends NinePatchRect
class_name Textbox

@onready var name_text: RichTextLabel = $Name
@onready var text_text: RichTextLabel = $Text
@onready var portrait_sprite: AnimatedSprite2D = $"Portait Box/Portrait"

var characters: Dictionary = {
	"pilot" = preload("res://characters/Gornzorple.tres"),
	"ai" = preload("res://characters/Squirt.tres"),
	"rival" = preload("res://characters/Blade.tres")
}

func _ready():
	Globals.textbox = self
	hide()
	show_text("Relax liberal, it's called dark humor.","rival","talk")
	await get_tree().create_timer(2).timeout
	show_text("What?","pilot","talk")
	await get_tree().create_timer(3).timeout
	show_text("I think he is attempting something called \"Cringe\"!","ai","talk")
	
func _process(delta):
	if(text_text.visible_ratio < 1):
		text_text.visible_ratio += delta
	
func show_text(text: String, character_id: String, animation: String):
	show()
	text_text.visible_ratio = 0
	var character = characters[character_id]
	if(!character):
		name_text.text = "ERROR"
	else:
		name_text.text = character.name
	text_text.text = text #why
	portrait_sprite.sprite_frames = character.portrait
	#portrait_sprite.animation = animation
	portrait_sprite.play(animation)
