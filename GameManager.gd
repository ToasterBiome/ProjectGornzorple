extends Node3D
class_name GameManager

@onready var player = $Player
@onready var shield = $"Radiation Shield Satellite/Shield"


@onready var satellite = $"Radiation Shield Satellite"
@onready var particle_field: GPUParticles3D = $GPUParticles3D
@onready var cutscene_particles: GPUParticles3D = $"Cutscene Particles"
@onready var death_screen = $"CanvasLayer/Death Screen"


@onready var shield_progress_bar: ProgressBar = $"CanvasLayer/Shield Percentage"
@onready var shooting_star_timer: Timer = $"Timers/Shooting Star Timer"
@onready var enemy_spawn_timer: Timer = $"Timers/Enemy Timer"

var shooting_star_scene = preload("res://scenes/shooting_star.tscn")

var enemy_scenes = [preload("res://scenes/enemy/big_chungus.tscn"), 
preload("res://scenes/enemy/alien_skipper.tscn"),
preload("res://scenes/enemy/pear_ship.tscn")
]

var current_shield = -1
var max_shield = 4

var shield_reduction_rate = 0.125

enum GAME_STATUS {
	GAME_INTRO,
	GAME_PLAYING,
	GAME_ENDED
}

var status: GAME_STATUS = GAME_STATUS.GAME_INTRO

func _ready():
	shooting_star_timer.timeout.connect(Callable(self,"_spawn_shooting_star"))
	enemy_spawn_timer.timeout.connect(Callable(self,"_spawn_enemy"))
	current_shield = max_shield
	shield_progress_bar.value = current_shield
	
	death_screen.hide()
	
	#setup cutscene
	
	satellite.hide()
	particle_field.emitting = false
	cutscene_particles.emitting = false
	
	await get_tree().create_timer(1.0).timeout
	Globals.textbox.set_character("ai")
	Globals.textbox.set_animation("talk")
	Globals.textbox.show_text("Congratulations on another successful parsec jump meteor smuggling dogfight mission, Gornzorple!")
	await get_tree().create_timer(3.0).timeout
	Globals.textbox.set_character("pilot")
	Globals.textbox.set_animation("talk")
	Globals.textbox.show_text("Thanks SQRT, it's smooth sailing from here on out. Activate my cryo sleep function and wake me when we're back on Gorzopolis!")
	await get_tree().create_timer(3.0).timeout
	cutscene_particles.emitting = true
	Globals.textbox.set_character("ai")
	Globals.textbox.set_animation("talk")
	Globals.textbox.show_text("Sure thing Gorn- Wait a minute... WATCH OUT!")
	await get_tree().create_timer(3.0).timeout
	Globals.textbox.set_character("pilot")
	Globals.textbox.set_animation("talk")
	Globals.textbox.show_text("Huh?")
	await Globals.textbox.on_text_finished
	await get_tree().create_timer(1.0).timeout
	Globals.textbox.set_character("ai")
	Globals.textbox.set_animation("talk")
	Globals.textbox.show_text("You're entering a Cosmic Bullet Radiation Field! Quick - Deploy the Techno-Anti-Radiation Shield!")
	await get_tree().create_timer(3.0).timeout
	satellite.show()
	await get_tree().create_timer(1.0).timeout
	Globals.textbox.set_animation("talk")
	Globals.textbox.show_text("Employing Techno-Anti-Radiation Shield. Utilize the Hercules Mark IV Ultimate System Mouse Button ONE to aim and the Icarus Mark VII WASD Keys to avoid the Cosmic Bullet Radiation Field! Good luck Gornzorple!")
	particle_field.emitting = true
	cutscene_particles.emitting = false
	await get_tree().create_timer(6.0).timeout
	var enemy = _spawn_enemy(2, Vector3(10, 9, 0))
	enemy.can_shoot = false #for the tutorial
	Globals.textbox.set_animation("talk")
	Globals.textbox.show_text("G-g-g-g-ghost ships! Shoot them down!")
	await get_tree().create_timer(3.0).timeout
	Globals.textbox.close_textbox()
	player.can_move = true
	shooting_star_timer.start()
	enemy_spawn_timer.start()
	status = GAME_STATUS.GAME_PLAYING


func _process(delta):
	match(status):
		GAME_STATUS.GAME_INTRO:
			pass
		GAME_STATUS.GAME_PLAYING:
			current_shield -= delta * shield_reduction_rate
			_update_shield(delta)
			_check_bounds()
		GAME_STATUS.GAME_ENDED:
			pass
	
func _update_shield(delta):
	shield.scale = shield.scale.lerp(Vector3(current_shield,current_shield,current_shield), delta * 2)
	#update the ui
	shield_progress_bar.value = current_shield / max_shield
	
func add_shield(amount):
	current_shield = min(current_shield + amount, max_shield)
	Globals.score += amount
	#_update_shield()
	
func _check_bounds():
	var distance = player.position.distance_to(Vector3.ZERO)
	if(distance > current_shield * 2):
		_die()
		
func _spawn_shooting_star():
	var new_shooting_star = shooting_star_scene.instantiate()
	add_child(new_shooting_star)
	var spawn_location = _get_random_spawn_location()
	var deviation = Vector3(randf_range(-2, 2), randf_range(-2, 2), 0)
	new_shooting_star.fire(spawn_location, spawn_location.direction_to(deviation))
	
func _spawn_enemy(type = null, overide_location = null):
	var enemy_type
	if(!type):
		enemy_type = enemy_scenes.pick_random()
	else:
		enemy_type = enemy_scenes[type]
	var new_enemy = enemy_type.instantiate()
	add_child(new_enemy)
	if(!overide_location):
		new_enemy.position = _get_random_spawn_location()
	else:
		new_enemy.position = overide_location
	return new_enemy
	
func _get_random_spawn_location():
	var x = randf_range(8.0, 16.0)
	var y = randf_range(8.0, 16.0)
	if(randf() > 0.5):
		x = -x
	if(randf() > 0.5):
		y = -y
	return Vector3(x, y, 0)
	
func _die():
	if(player.dead):
		return
	status = GAME_STATUS.GAME_ENDED
	player.can_move = false
	player.dead = true
	#play boom effect here
	Globals.textbox.set_character("ai")
	Globals.textbox.set_animation("talk")
	Globals.textbox.show_text("NO!!!!!")
	Globals.textbox.set_animation("worried")
	await get_tree().create_timer(2.0).timeout
	death_screen.show()
	death_screen.update()
	
	
