extends RigidBody2D

var velocity = Vector2.ZERO
var speed = 2

func _physics_process(delta):
	if(Input.get_action_strength("left")):
		velocity += Vector2.LEFT * delta * speed
	if(Input.get_action_strength("right")):
		velocity += Vector2.RIGHT * delta * speed
	if(Input.get_action_strength("up")):
		velocity += Vector2.UP * delta * speed
	if(Input.get_action_strength("down")):
		velocity += Vector2.DOWN * delta * speed
	move_and_collide(velocity)
