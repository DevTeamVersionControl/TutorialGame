extends GutTest

func test_new_level_Level0_Initializes_Spawns() -> void:
	# Given
	var level_system : LevelSystem = autofree(LevelSystem.new())
	var tower_spot_double : TowerSpot = autofree(double(TowerSpot).new())
	
	var tower_spot_parent : Node = Node.new()
	add_child_autofree(tower_spot_parent)
	tower_spot_parent.add_child(tower_spot_double)
	
	# When
	level_system.new_level(tower_spot_parent)
	
	# Then
	assert_eq(level_system.active_tower_spots, {0:level_system.initial_tower_request})
	assert_eq(level_system.available_tower_spots, [])
	assert_eq(level_system.level, 1)
	assert_called(tower_spot_double, "spawn_tower")

func test_new_level_Level1_DoesNotInitialize() -> void:
	# Given
	var level_system : LevelSystem = autofree(LevelSystem.new())
	level_system.level = 1
	
	var tower_spot_parent : Node = Node.new()
	add_child_autofree(tower_spot_parent)
	
	var tower_spot : TowerSpot = TowerSpot.new()
	tower_spot.tower_prefab_internal = autofree(double(PackedSceneMock).new())
	tower_spot_parent.add_child(tower_spot)
	
	# When
	level_system.new_level(tower_spot_parent)
	
	# Then
	assert_eq(level_system.active_tower_spots, {})
	assert_eq(level_system.available_tower_spots, [])
	assert_eq(level_system.level, 1)

func test_new_level_GivenTowerSpots_SpawnsThem() -> void:
	# Given
	var level_system : LevelSystem = autofree(LevelSystem.new())
	var tower_spot_double : TowerSpot = autofree(double(TowerSpot).new())
	
	var tower_spot_parent : Node = Node.new()
	add_child_autofree(tower_spot_parent)
	tower_spot_parent.add_child(tower_spot_double)
	
	# When
	level_system.new_level(tower_spot_parent)
	
	# Then
	assert_eq(level_system.active_tower_spots, {0:level_system.initial_tower_request})
	assert_eq(level_system.available_tower_spots, [])
	assert_eq(level_system.level, 1)
	assert_called(tower_spot_double, "spawn_tower")

func test_increase_level_IncreasesLevel_KeepsSameTowers_AddsNewTower() -> void:
	# Given
	var level_system : LevelSystem = autofree(LevelSystem.new())
	level_system.level = 5
	level_system.available_tower_spots = range(5, 10)
	level_system.active_tower_spots = { 0:level_system.initial_tower_request, 
										1:level_system.initial_tower_request,
										2:level_system.initial_tower_request, 
										3:level_system.initial_tower_request,
										4:level_system.initial_tower_request }
	
	# When 
	level_system.increase_level()
	
	# Then
	assert_eq(level_system.active_tower_spots.size(), 6)
	assert_eq(level_system.level, 6)
	assert_eq(level_system.active_tower_spots.keys().slice(0, 5), range(5))
