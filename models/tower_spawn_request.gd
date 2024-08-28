class_name TowerSpawnRequest
extends Resource

@export var health : float
@export var shot_cooldown_seconds : float
@export var bullet_damage : float
@export var bullet_speed : float

func _init(p_health, p_shot_cooldown_seconds, p_bullet_damage, p_bullet_speed):
	health = p_health
	shot_cooldown_seconds = p_shot_cooldown_seconds
	
	bullet_damage = p_bullet_damage
	bullet_speed = p_bullet_speed
