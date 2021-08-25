extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = 170 
export (int) var hold_jump_speed = 15
export (int) var gravity = 18
export (float, 0, 1.0) var friction = 0.4
export (float, 0, 1.0) var acceleration = 0.15
export (float) var impulse_force = 1

var velocity = Vector2.ZERO

onready var state_machine = $AnimationTree.get("parameters/playback")

var last_collider = null
var prev_velocity

func _physics_process(_delta: float):
	move()
	collide()
	
func move():
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
	velocity.y += gravity
	
	if Input.is_action_just_pressed("ui_select"):
		$PressedJumpTimer.start()
	
	if not $PressedJumpTimer.is_stopped() and not $FloorTimer.is_stopped():
		$PressedJumpTimer.stop()
		$LeapTimer.start()
		state_machine.travel("jump")
		velocity.y -= jump_speed
	elif Input.is_action_pressed("ui_select"):
		if not $LeapTimer.is_stopped():
			velocity.y -= hold_jump_speed
		else:
			$LeapTimer.stop()
	
	prev_velocity = Vector2(velocity)
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	
	if direction > 0:
		$Sprite.set_flip_h(false)
	elif direction < 0:
		$Sprite.set_flip_h(true)
	
	if is_on_floor():
		$FloorTimer.start()
		
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			state_machine.travel("run")

		if abs(velocity.x) < speed * 0.05:
			state_machine.travel("idle")
	else:
		if velocity.y > 0 and $FallTimer.is_stopped():
			state_machine.travel("fall")
			


func collide():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		var collider = collision.collider
		if collider.is_in_group("island"):
			if collider.frozen:
				collider.apply_central_impulse(Vector2(prev_velocity) * impulse_force)
				collider.unfreeze()
		$FallTimer.start()
	
