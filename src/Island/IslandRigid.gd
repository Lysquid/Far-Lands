extends RigidBody2D

func _ready() -> void:
	mass = $TileMap.get_used_cells_by_id(0).size()
