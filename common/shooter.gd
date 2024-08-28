class_name Shooter
extends Node3D

@export var bullet_damage : float = 5
@export var bullet_speed : float = 5

func shoot(direction : Vector3) -> void:
	var bullet : Bullet = RessourceMappings.BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.initialize(direction, bullet_damage, bullet_speed)
