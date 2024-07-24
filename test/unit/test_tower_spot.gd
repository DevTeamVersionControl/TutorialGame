extends GutTest

func test_spawn_tower_HappyPath_SpawnsTowerDeletesSelfAndPassesArguments() -> void:
	# Given
	var args : TowerSpawnRequest = TowerSpawnRequest.new(5, 5, 5)
	var position := Vector3(10, 0, 0)
	var rotation : float = PI
	var tower_double : Node3D = autofree(double(Node3D).new())
	
	var tower_prefab_double : PackedScene = autofree(double(PackedScene).new())
	stub(tower_prefab_double, "instantiate").to_return(tower_double)
	
	var tower_spot : TowerSpot = autofree(TowerSpot.new())
	add_child_autofree(tower_spot)
	tower_spot.global_position = position
	tower_spot.rotation.y = rotation
	#tower_spot.tower_prefab = tower_prefab_double
	
	# When
	tower_spot.spawn_tower(args)
	await wait_frames(1)
	
	# Then 
	assert_freed(tower_spot)
	assert_called(tower_prefab_double, "instantiate")
	assert_called(tower_double, "initialize", args)
	assert_almost_eq(tower_double.global_position, position, Vector3.ONE * 0.01)
	assert_almost_eq(tower_double.rotation, rotation, 0.01)
