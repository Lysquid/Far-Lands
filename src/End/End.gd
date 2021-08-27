extends Node2D

var character
var complete_time

func _ready() -> void:
	position = Vector2.ZERO
	$Camera2D/Text.visible = false

func play_credits(_character, time):
	character = _character
	complete_time = int(time)
	$Delay.start()

func _on_Delay_timeout() -> void:
	global_position.x = 224
	global_position.y = character.get_node("Camera2D").global_position.y

	$Camera2D.make_current()
	$Camera2D/AnimationPlayer.play("End")
	
	$Camera2D/Text/Subtext/Congrats.text += str(complete_time / 60) + "min and "+str(complete_time % 60) +"s"
	
