extends Node3D

@export var test_tower_spot : TowerSpot

func _ready():
	if test_tower_spot != null:
		test_tower_spot.spawn_tower(TowerSpawnRequest.new(50, 2, 10, 5))

