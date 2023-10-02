extends RigidBody3D
class_name Enemy

var health: int = 0
@export var max_health: int = 10

@onready var player = $"../Player"
@onready var firing_timer: Timer = $"Firing Timer"

@export var firing_points: Array[Node3D]
@export var firing_range: float = 10.0

@export var speed: float = 1.0

var shot = preload("res://scenes/enemy_shot.tscn")

var firing_index: int = 0
@export var auto_look: bool = true
@export var look_once: bool = false

func _ready():
	health = max_health
	firing_timer.timeout.connect(Callable(self,"_fire"))
	if(look_once):
		look_at(player.position, Vector3.BACK, true)
	
	
func _physics_process(delta):
	if(auto_look):
		look_at(player.position, Vector3.BACK, true)
	move_and_collide(basis.z * delta * speed)

func _fire():
	if(!_in_range() || !firing_points.size()):
		return
	firing_index += 1
	if(firing_index > firing_points.size() - 1):
		firing_index = 0
	var index: Node3D = firing_points[firing_index]
	var new_shot = shot.instantiate()
	get_tree().get_root().add_child(new_shot)
	new_shot.fire(index.global_position, index.get_global_transform().basis.z)
	
func _in_range():
	return (position.distance_to(player.position) <= firing_range)
	
func hit(body: Node3D):
	health -= 1
	if(health <= 0):
		queue_free()
	
