extends NinePatchRect
class_name Textbox

@onready var name_text: RichTextLabel = $Name
@onready var text_text: RichTextLabel = $Text
@onready var portrait_sprite: AnimatedSprite2D = $"Portait Box/Portrait"

var open_tween: Tween
var open = false
var text_tween: Tween

@onready var talking_sound: AudioStreamPlayer = $Talking

var characters: Dictionary = {
	"pilot" = preload("res://characters/Gornzorple.tres"),
	"ai" = preload("res://characters/Squirt.tres"),
	"rival" = preload("res://characters/Blade.tres")
}

signal on_text_finished

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
		
func set_character(character_id: String):
	var character = characters[character_id]
	if(!character):
		name_text.text = "ERROR"
	else:
		name_text.text = character.name
	portrait_sprite.sprite_frames = character.portrait

func set_animation(animation: String):
	portrait_sprite.animation = animation
	portrait_sprite.play(animation)
	
func show_text(text: String):
	if(!open):
		open = true
		show()
		scale.y = 0
		open_tween = get_tree().create_tween()
		open_tween.tween_property(self,"scale",Vector2(1,1), 0.25)
	text_text.visible_ratio = 0
	text_text.text = text #why
	if(text_tween):
		text_tween.kill()
	talking_sound.play()
	text_tween = get_tree().create_tween()
	text_tween.tween_property(text_text, "visible_ratio", 1, 0.0625 * text_text.text.length())
	await text_tween.finished
	emit_signal("on_text_finished")
	talking_sound.stop()
	if(portrait_sprite.animation == "talking"):
		set_animation("default")
	
	
func close_textbox():
	text_text.text = ""
	portrait_sprite.sprite_frames = null
	open_tween = get_tree().create_tween()
	open_tween.tween_property(self,"scale",Vector2(1,0), 0.25)
	await open_tween.finished
	hide()
	open = false
