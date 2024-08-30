class_name LevelSystem extends Node

var level : int = 0
var active_tower_spots : Dictionary
var available_tower_spots : Array
var tower_spots : Array[TowerSpot]
var initial_tower_request := TowerSpawnRequest.new(50, 2, 10, 5)

func initialize():
	active_tower_spots = {}
	available_tower_spots = range(tower_spots.size())
	increase_level()

func increase_level() -> void:
	level += 1
	active_tower_spots[choose_tower_spot()] = initial_tower_request

func choose_tower_spot() -> int:
	return available_tower_spots.pop_at(randi_range(0, available_tower_spots.size()-1))

func get_all_tower_spots(tower_spots_parent : Node) -> Array[TowerSpot]:
	var cast_tower_spots : Array[TowerSpot] = []
	for child in tower_spots_parent.get_children():
		if child is TowerSpot:
			cast_tower_spots.append(child as TowerSpot)
	return cast_tower_spots

func spawn_towers(tower_spots_parent : Node) -> void:
	tower_spots = get_all_tower_spots(tower_spots_parent)
	if level == 0:
		initialize()
	for tower_spot_index in active_tower_spots.keys() as Array:
		tower_spots[tower_spot_index].spawn_tower(active_tower_spots[tower_spot_index] as TowerSpawnRequest)
