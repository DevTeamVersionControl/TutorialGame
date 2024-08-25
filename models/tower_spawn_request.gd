class_name TowerSpawnRequest
extends Resource

@export var health : float
@export var damage : float
@export var shot_cooldown_seconds : float

func _init(p_health, p_damage, p_shot_cooldown_seconds):
	health = p_health
	damage = p_damage
	shot_cooldown_seconds = p_shot_cooldown_seconds
