extends RigidBody3D

var velocity = Vector3.ZERO
var acceleration = 0.45
var max_speed = 0.25
var braking_speed = 0.95

@onready var camera = $"../Camera3D"
@onready var model = $PlayerShip
@onready var shootOffset = $"PlayerShip/Shoot Offset"

var shot_scene = preload("res://scenes/shot.tscn")

@onready var manager = $".."

var next_shot = 0
var shot_delay = 100 #ms

func _physics_process(delta):
	var x = -Input.get_action_strength("left") + Input.get_action_strength("right")
	var y = -Input.get_action_strength("up") + Input.get_action_strength("down")
	velocity += Vector3.RIGHT * x * delta * acceleration
	velocity += Vector3.DOWN * y * delta * acceleration
	if(velocity.length() > max_speed):
		velocity = velocity.normalized() * max_speed
	if(!x && !y):
		velocity *= braking_speed
	move_and_collide(velocity)
	model.look_at(camera.project_position(get_viewport().get_mouse_position(),camera.position.z), Vector3.FORWARD, true)

func _process(delta):
	if(Input.get_action_strength("shoot")):
		if(next_shot <= Time.get_ticks_msec()):
			next_shot = Time.get_ticks_msec() + shot_delay
			var new_shot = shot_scene.instantiate()
			get_tree().get_root().add_child(new_shot)
			new_shot.fire(shootOffset.global_position, shootOffset.get_global_transform().basis.z)
			
func hit(body: Node3D):
	var shot_type: Shot.ShotType = body.get("shot_type")
	if(!shot_type):
		return
	if(shot_type == 2):
		manager.add_shield(1)
	print(body.shot_type)
