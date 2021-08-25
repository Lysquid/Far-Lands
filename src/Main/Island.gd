extends KinematicBody2D

var velocity = Vector2.ZERO

func _physics_process(_delta: float):
	move_and_slide(velocity)
	
	
