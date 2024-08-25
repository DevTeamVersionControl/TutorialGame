extends Node3D
class_name Tower

var settings : TowerSpawnRequest

func initialize(tower_spawn_request : TowerSpawnRequest) -> void:
	settings = tower_spawn_request

