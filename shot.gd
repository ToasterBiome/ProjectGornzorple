extends Area3D
class_name Shot

var direction

@export var speed = 90

@onready var mesh = $MeshInstance3D

@export var lifetime: float = 2.0

@export var shooting_star: bool = false

enum ShotType {
	Enemy,
	Player,
	ShootingStar
}

@export var shot_type : ShotType = ShotType.Enemy

func _ready():
	body_entered.connect(Callable(self, "on_body_entered"))

func _physics_process(delta):
	#direction = global_transform.basis.z.norm
	position += direction * delta * speed
	#move_and_collide(direction * delta * speed)
	
func _process(delta):
	lifetime -= delta
	if(lifetime < 0):
		queue_free()
	
	
func fire(fire_pos, rot):
	global_position = fire_pos
	direction = rot
	mesh.look_at(global_position + direction, Vector3.BACK)
	
func on_body_entered(body: Node3D):
	print("hit")
	if(body.has_method("hit")):
		body.hit(self)
	if(shooting_star):
		var pickup_sound = Globals.star_pickup_scene.instantiate()
		get_parent().add_child(pickup_sound)
	queue_free()
