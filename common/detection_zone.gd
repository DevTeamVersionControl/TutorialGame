extends Area3D
class_name DetectionZone

@onready var collision_shape := $CollisionShape3D

func is_player_in_zone() -> bool:
	var overlapping_bodies : Array[Node3D] = get_overlapping_bodies()
	for overlapping_body in overlapping_bodies:
		if overlapping_body is Player:
			return true
	return false

func get_player() -> Player:
	var overlapping_bodies : Array[Node3D] = get_overlapping_bodies()
	for overlapping_body in overlapping_bodies:
		if overlapping_body is Player:
			return overlapping_body
	return null
