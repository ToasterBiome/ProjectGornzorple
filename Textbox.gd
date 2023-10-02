extends NinePatchRect
class_name Textbox

@onready var name_text: RichTextLabel = $Name
@onready var text_text: RichTextLabel = $Text
@onready var portrait_sprite: AnimatedSprite2D = $"Portait Box/Portrait"

var open_tween: Tween
var open = false

var characters: Dictionary = {
	"pilot" = preload("res://characters/Gornzorple.tres"),
	"ai" = preload("res://characters/Squirt.tres"),
	"rival" = preload("res://characters/Blade.tres")
}

func _ready():
	Globals.textbox = self
	hide()
	
#	show_text("Relax liberal, it's called dark humor.","rival","talk")
#	await get_tree().create_timer(2).timeout
#	show_text("What?","pilot","talk")
#	await get_tree().create_timer(2).timeout
#	show_text("I think he is attempting something called \"Cringe\"!","ai","talk")
#	await get_tree().create_timer(2).timeout
#	close_textbox()
	
func _process(delta):
	if(text_text.visible_ratio < 1):
		text_text.visible_ratio += delta
	
func show_text(text: String, character_id: String, animation: String):
	if(!open):
		open = true
		show()
		scale.y = 0
		open_tween = get_tree().create_tween()
		open_tween.tween_property(self,"scale",Vector2(1,1), 0.25)
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
	
func close_textbox():
	text_text.text = ""
	portrait_sprite.sprite_frames = null
	open_tween = get_tree().create_tween()
	open_tween.tween_property(self,"scale",Vector2(1,0), 0.25)
	await get_tree().create_timer(0.25).timeout
	hide()
	open = false
