extends RigidBody3D
class_name Enemy

var health: int = 0
var max_health: int = 10

@onready var player = $"../Player"
@onready var firing_timer: Timer = $"Firing Timer"

@export var firing_points: Array[Node3D]

var shot = preload("res://scenes/enemy_shot.tscn")

var firing_index: int = 0

func _ready():
	health = max_health
	firing_timer.timeout.connect(Callable(self,"_fire"))
	
	
func _physics_process(delta):
	look_at(player.position, Vector3.BACK, true)
	move_and_collide(basis.z * delta)

func _fire():
	firing_index += 1
	if(firing_index > firing_points.size() - 1):
		firing_index = 0
	var index: Node3D = firing_points[firing_index]
	var new_shot = shot.instantiate()
	get_tree().get_root().add_child(new_shot)
	new_shot.fire(index.global_position, index.get_global_transform().basis.z)
	
func hit():
	health -= 1
	if(health <= 0):
		queue_free()
	
