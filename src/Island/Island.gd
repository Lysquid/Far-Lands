extends KinematicBody2D

var frozen = true
var velocity = Vector2(15, 25)
onready var mass = $TileMap.get_used_cells_by_id(0).size()

func unfreeze():
	set_modulate(Color(1,1,1))
	frozen = false
	
func _physics_process(_delta):
	#move_and_slide(linear_velocity: Vector2, up_direction: Vector2 = Vector2( 0, 0 ), stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398, infinite_inertia: bool = true)
	var prev_pos = Vector2(position)
	move_and_slide(velocity, Vector2(0,0), false, 4)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		var collider = collision.collider
		if not collider.is_in_group("character"):
			if collision.normal.x == 0:
				velocity.y *= -1
			elif collision.normal.y == 0:
				velocity.x *= -1
		"""elif false:
			print(velocity * _delta, velocity * _delta - collision.travel, collision.remainder)
			var mov = collision.normal * collision.normal.dot(velocity * _delta - collision.travel)
			position += mov
			collider.position += mov"""
