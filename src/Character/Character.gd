extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = 170
export (int) var hold_jump_speed = 16
export (int) var gravity = 18
export (int) var max_fall_speed = 250
export (float, 0, 1.0) var friction = 0.4
export (float, 0, 1.0) var acceleration = 0.15
export (float) var impulse_force = 2

var velocity = Vector2.ZERO

onready var state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(_delta: float):
	
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
	velocity.y += gravity if velocity.y < max_fall_speed else 0
	
	if Input.is_action_just_pressed("ui_select"):
		$PressedJumpTimer.start()
	
	# VERY IMPORTANT LINE THAT SHIT MADE ME STUCK FOR 2 DAYS
	var snap_vector = Vector2.DOWN * 3
	
	if not $PressedJumpTimer.is_stopped() and not $FloorTimer.is_stopped():
		$PressedJumpTimer.stop()
		state_machine.travel("jump")
		
		velocity += get_floor_normal() * jump_speed
		$LeapTimer.start()
		snap_vector = Vector2.ZERO
		
		
	elif Input.is_action_pressed("ui_select"):
		if not $LeapTimer.is_stopped() and not is_on_floor() and not is_on_ceiling():
			velocity.y -= hold_jump_speed
		else:
			$LeapTimer.stop()
	
	
	# Adding platform's velocity to player velocity : NOT WORKING
	#if is_on_floor():
	#	velocity += get_floor_velocity() * 0.004 #.dot(Vector2.UP) * Vector2.UP * 0.2

	
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, false, 4, PI/2 * 0.7, true)

	
	if direction > 0:
		$Sprite.set_flip_h(false)
	elif direction < 0:
		$Sprite.set_flip_h(true)
	
	if is_on_floor():
		$FloorTimer.start()
		
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			state_machine.travel("run")
		else:
			state_machine.travel("idle")
	else:
		if velocity.y > 0 and $FloorTimer.is_stopped():
			state_machine.travel("fall")
			
	# Stuck
	if Input.is_action_just_pressed("stuck"):
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
	if Input.is_action_just_released("stuck"):
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
