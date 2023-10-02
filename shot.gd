extends Area3D
class_name Shot

var direction

@export var speed = 90

@onready var mesh = $MeshInstance3D

@export var lifetime: float = 2.0

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
	var degrees = rad_to_deg(position.angle_to(position + direction))
	mesh.look_at(global_position + direction, Vector3.BACK)
	
func on_body_entered(body: Node3D):
	print("hit")
	if(body.has_method("hit")):
		body.hit(self)
	queue_free()
