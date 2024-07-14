extends Node
class_name Damageable

signal took_damage

func take_damage(_damage : float, _direction : Vector3):
	emit_signal("took_damage")
