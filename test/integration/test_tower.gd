extends GutTest

var tower_detection_radius : float
var default_tower_spawn_request = TowerSpawnRequest.new(50, 0.1, 1, 50)

func before_all() -> void:
	var tower : Tower = autofree(RessourceMappings.TOWER_SCENE.instantiate())
	add_child(tower)
	tower_detection_radius = tower.player_detector.collision_shape.shape.radius
	remove_child(tower)

func test_PlayerOutOfRange_DoesNothing() -> void:
	# Given
	var values = setup_test_scene()
	var player : Player = values["player"]
	player.global_position = Vector3.BACK * (tower_detection_radius+1)
	watch_signals(player)
	
	var tower : Tower = values["tower"]
	tower.initialize(default_tower_spawn_request)
	tower.shooter.bullet_speed = 50
	
	# When
	await wait_for_signal(player.took_damage, 1.5)
	
	# Then
	assert_signal_not_emitted(player, "took_damage")

func test_PlayerInRange_ShootsAtPlayer() -> void:
	# Given
	var values = setup_test_scene()
	var player : Player = values["player"]
	player.global_position = Vector3.BACK * (tower_detection_radius-1)
	
	var tower : Tower = values["tower"]
	tower.initialize(default_tower_spawn_request)
	tower.shooter.bullet_speed = 50
	
	# When
	await wait_for_signal(player.took_damage, 1)
	
	# Then
	assert_signal_emitted(player, "took_damage")

func test_PlayerShootsTower_TowerTakesDamage() -> void:
	# Given
	var values = setup_test_scene()
	var player : Player = values["player"]
	player.global_position = Vector3.BACK * (tower_detection_radius-3)
	player.shooter.bullet_speed = 20
	player.shooter.bullet_damage = 1
	
	var tower : Tower = values["tower"]
	tower.health = 100.0
	
	# When
	await wait_frames(1)
	player.shoot()
	await wait_for_signal(tower.took_damage, 1.5)
	
	# Then
	assert_not_freed(tower, "tower")
	assert_signal_emitted(tower, "took_damage")

func setup_test_scene() -> Dictionary:
	var player : Player = RessourceMappings.PLAYER_SCENE.instantiate()
	var tower : Tower = RessourceMappings.TOWER_SCENE.instantiate()
	add_child_autofree(player)
	player.axis_lock_linear_y = true
	add_child_autofree(tower)
	return {"tower":tower, "player":player}
