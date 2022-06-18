extends KinematicBody2D

var velocity := Vector2.ZERO
export(int) var max_speed = 100
export(float) var gravity = 20
export(int) var jump_speed = 10000
export(int) var acceleration = 25
export(int) var friction = 25

enum states {IDLE, MOVE, JUMP, SWALLOW, HIT, DIE, FALL}
var state = states.IDLE

export(NodePath) onready var anim = get_node(anim) as AnimationPlayer
export(NodePath) onready var sprites = get_node(sprites) as Node2D

func _physics_process(delta: float) -> void:
	
	handle_movement()
	check_all()
				
	
	if state != states.JUMP:
		velocity.y += gravity
		
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	for sprite in sprites.get_children():
		sprite.hide()
		if sprite.name == anim_name:
			sprite.show()
			
	if anim_name == "jump":
		state = states.IDLE
	
func handle_movement() -> void:
	var input_vector = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
		
	if input_vector != 0:
		velocity.x = move_toward(velocity.x, max_speed * input_vector, acceleration)
		for sprite in sprites.get_children():
			sprite.flip_h = input_vector < 0
			if sprite.flip_h:
				sprite.set_offset(Vector2(-10, 0))
			else:
				sprite.set_offset(Vector2.ZERO)
		
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		anim.play("jump")
		
func play_anims() -> void:
	match state:
		states.IDLE: 
			anim.play("idle")
			
		states.MOVE:
			anim.play("move")
			
		states.JUMP:
			anim.play("jump")
			
		states.HIT:
			anim.play("hit")
			
		states.SWALLOW:
			anim.play("swallow")
			
		states.DIE:
			anim.play("die")
			
		states.FALL:
			anim.play("idle")
			
			
func check_all():
	if anim.current_animation == "jump":
		state = states.JUMP
		print("jumping")
		
	elif velocity.x == 0 and is_on_floor():
		state = states.IDLE
		
	elif velocity.x != 0 and is_on_floor():
		state = states.MOVE
		
	elif velocity.y >= 0 and !is_on_floor():
		state = states.FALL
