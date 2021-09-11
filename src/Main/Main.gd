extends Node

var time = 0
var music = false

func _process(delta: float) -> void:
	time += delta
	if not music and Input.is_action_pressed("ui_select"):
		music = true
		$Music.play()
	if Input.is_action_just_pressed("reset"):
		# Godot gives warning if i don't use the returne value
		var _useless = get_tree().reload_current_scene()
	if Input.is_action_just_pressed("stop_music"):
		$Music.stream_paused = not $Music.stream_paused 
	
func _on_Map_end() -> void:
	$End.play_credits($Character, time)
	
