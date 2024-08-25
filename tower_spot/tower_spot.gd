class_name TowerSpot
extends Node3D

@export var tower_prefab : PackedScene
@onready var tower_prefab_internal = tower_prefab

func spawn_tower(tower_spawn_request : TowerSpawnRequest) -> void:
	var tower = tower_prefab_internal.instantiate()
	get_parent().add_child(tower)
	tower.global_position = global_position
	tower.global_rotation = global_rotation
	tower.initialize(tower_spawn_request)
	queue_free()
