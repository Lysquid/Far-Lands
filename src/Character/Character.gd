extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = 170
export (int) var hold_jump_speed = 15
export (int) var gravity = 18
export (float, 0, 1.0) var friction = 0.5
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO

onready var state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(_delta: float):
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
	elif Input.is_action_pressed("ui_select") and not $LeapTimer.is_stopped():
		velocity.y -= hold_jump_speed
		#velocity.y =- hold_jump_speed

	velocity = move_and_slide(velocity, Vector2.UP)
	
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
		if velocity.y > 0:
			state_machine.travel("fall")
