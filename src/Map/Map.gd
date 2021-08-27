extends Node2D

signal end


func _on_Area2D_body_entered(_body: Node) -> void:
	print(_body)
	emit_signal("end")
	$Area2D.set_deferred("monitoring", false)
