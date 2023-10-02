extends Node3D

@onready var player = $Player
@onready var shield = $"Radiation Shield Satellite/Shield"


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

func _ready():
	shooting_star_timer.timeout.connect(Callable(self,"_spawn_shooting_star"))
	enemy_spawn_timer.timeout.connect(Callable(self,"_spawn_enemy"))
	current_shield = max_shield
	shield_progress_bar.value = current_shield


func _process(delta):
	current_shield -= delta * shield_reduction_rate
	_update_shield(delta)
	_check_bounds()
	
func _update_shield(delta):
	shield.scale = shield.scale.lerp(Vector3(current_shield,current_shield,current_shield), delta * 2)
	#update the ui
	shield_progress_bar.value = current_shield / max_shield
	
func add_shield(amount):
	current_shield = min(current_shield + amount, max_shield)
	#_update_shield()
	
func _check_bounds():
	var distance = player.position.distance_to(Vector3.ZERO)
	if(distance > current_shield * 2):
		print("exploded")
		
func _spawn_shooting_star():
	var new_shooting_star = shooting_star_scene.instantiate()
	add_child(new_shooting_star)
	var spawn_location = _get_random_spawn_location()
	var deviation = Vector3(randf_range(-2, 2), randf_range(-2, 2), 0)
	new_shooting_star.fire(spawn_location, spawn_location.direction_to(deviation))
	
func _spawn_enemy():
	var enemy_type = enemy_scenes.pick_random()
	var new_enemy = enemy_type.instantiate()
	add_child(new_enemy)
	new_enemy.position = _get_random_spawn_location()
	
func _get_random_spawn_location():
	var x = randf_range(8.0, 16.0)
	var y = randf_range(8.0, 16.0)
	if(randf() > 0.5):
		x = -x
	if(randf() > 0.5):
		y = -y
	return Vector3(x, y, 0)
	
	
