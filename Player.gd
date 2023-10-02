extends RigidBody3D

var velocity = Vector3.ZERO
var acceleration = 0.45
var max_speed = 0.25
var braking_speed = 0.95

@onready var camera = $"../Camera3D"
@onready var model = $PlayerShip
@onready var dead_model = $Player_ship_destroyed
@onready var explosion = $Human_particle_explosion
@onready var shootOffset = $"PlayerShip/Shoot Offset"

var shot_scene = preload("res://scenes/shot.tscn")

@onready var manager = $".."

var next_shot = 0
var shot_delay = 100 #ms

var can_move = false
var dead = false

#audio stuff
@onready var shoot_sound:AudioStreamPlayer3D = $Shoot
@onready var damage_sound: AudioStreamPlayer3D = $Damage

func _ready():
	look_at(Vector3.UP, Vector3.FORWARD, true)

func _physics_process(delta):
	var x = 0
	var y = 0
	if(can_move):
		x = -Input.get_action_strength("left") + Input.get_action_strength("right")
		y = -Input.get_action_strength("up") + Input.get_action_strength("down")
	
	velocity += Vector3.RIGHT * x * delta * acceleration
	velocity += Vector3.DOWN * y * delta * acceleration
	if(velocity.length() > max_speed):
		velocity = velocity.normalized() * max_speed
	if(!x && !y):
		velocity *= braking_speed
	move_and_collide(velocity)
	if(can_move):
		model.look_at(camera.project_position(get_viewport().get_mouse_position(),camera.position.z), Vector3.FORWARD, true)

func _process(_delta):
	if(Input.get_action_strength("shoot") && can_move):
		if(next_shot <= Time.get_ticks_msec()):
			shoot_sound.play()
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
	else:
		explode()
		manager._die()

func explode():
	if(dead):
		return
	model.hide()
	explosion.emitting = true
	dead_model.show()
	var death_sound = Globals.explosion_scene.instantiate()
	get_parent().add_child(death_sound)
		
