extends RigidBody3D
class_name Enemy

var health: int = 0
@export var max_health: int = 10

@onready var player = $"../Player"
@onready var firing_timer: Timer = $"Firing Timer"
@onready var manager = $"../"

@export var firing_points: Array[Node3D]
@export var firing_range: float = 10.0

@export var speed: float = 1.0

var shot = preload("res://scenes/enemy_shot.tscn")

var firing_index: int = 0
@export var auto_look: bool = true
@export var look_once: bool = false

var can_shoot = true

@onready var shoot_sound: AudioStreamPlayer3D = $Shoot
@onready var damage_sound: AudioStreamPlayer3D = $Damage

@export var model: MeshInstance3D
@export var dead_model: MeshInstance3D
@onready var explosion = $Radiation_particle_explosion

@onready var hitbox = $CollisionShape3D

@export var choreograph: bool = true

func _ready():
	health = max_health
	firing_timer.timeout.connect(Callable(self,"_fire"))
	if(look_once):
		look_at(player.position, Vector3.BACK, true)
	if(choreograph):
		await get_tree().create_timer(1).timeout
		var chor = Globals.choreograph_scene.instantiate()
		get_parent().add_child(chor)
		chor.global_position = global_position
		chor.look_at(player.position, Vector3.BACK, true)
		
	
	
func _physics_process(delta):
	if(health <= 0):
		return
	if(player.dead):
		return
	if(auto_look):
		look_at(player.position, Vector3.BACK, true)
	move_and_collide(basis.z * delta * speed)

func _fire():
	if(manager.status != GameManager.GAME_STATUS.GAME_PLAYING):
		return
	if(!can_shoot):
		return
	if(!_in_range() || !firing_points.size()):
		return
	shoot_sound.play()
	firing_index += 1
	if(firing_index > firing_points.size() - 1):
		firing_index = 0
	var index: Node3D = firing_points[firing_index]
	var new_shot = shot.instantiate()
	get_tree().get_root().add_child(new_shot)
	new_shot.fire(index.global_position, index.get_global_transform().basis.z)
	
func _in_range():
	return (position.distance_to(player.position) <= firing_range)
	
func hit(_body: Node3D):
	if(health <= 0):
		return
	health -= 1
	damage_sound.play()
	if(health <= 0):
		var death_sound = Globals.explosion_scene.instantiate()
		get_parent().add_child(death_sound)
		can_shoot = false
		model.hide()
		dead_model.show()
		explosion.emitting = true
		Globals.score += 10
		call_deferred("_disable_hitbox")
		await get_tree().create_timer(2.0).timeout
		queue_free()
		
func _disable_hitbox():
	hitbox.disabled = true
		
	
