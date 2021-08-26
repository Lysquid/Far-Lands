extends RigidBody2D

var frozen = true

func _ready() -> void:
	#set_mass($TileMap.get_used_cells_by_id(0).size())
	pass
	
func unfreeze():
	set_modulate(Color(1,1,1))
	frozen = false
	
