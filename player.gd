extends KinematicBody2D

var velocity := Vector2.ZERO
export(int) var max_speed = 100
export(float) var gravity = 9.8
export(int) var jump_speed = 100
export(int) var acceleration = 25
export(int) var friction = 25

export(NodePath) onready var anim = get_node(anim) as AnimatedSprite

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if input_vector != 0:
		velocity.x = move_toward(velocity.x, max_speed * input_vector, acceleration)
		anim.play("run")
		anim.flip_h = input_vector < 0
		
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		anim.play("idle")
	
	var jump_vector = Input.get_action_strength("jump")
	
	if jump_vector != 0 and is_on_floor():
		velocity.y -= jump_speed * jump_vector
		anim.play("jump")
		
	velocity.y += gravity
	
	velocity = move_and_slide(velocity)
