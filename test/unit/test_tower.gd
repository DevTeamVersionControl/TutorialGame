extends GutTest

var tower_detection_radius : float
var default_tower_spawn_request = TowerSpawnRequest.new(50, 0.1, 1, 50)

func test_initialize_GivenRequest_MapsRequestCorrectly() -> void:
	# Given
	var health = 5.0
	var shot_cooldown_seconds = 2.0
	var damage = 5.0
	var speed = 5.0
	var tower_spawn_request = autofree(TowerSpawnRequest.new(health, shot_cooldown_seconds, damage, speed))
	
	var tower : Tower = RessourceMappings.TOWER_SCENE.instantiate()
	add_child_autofree(tower)
	
	# When
	tower.initialize(tower_spawn_request)
	
	# Then
	assert_almost_eq(tower.health, health, 0.01)
	assert_almost_eq(tower.timer.wait_time, shot_cooldown_seconds, 0.01)
	assert_almost_eq(tower.shooter.bullet_damage, damage, 0.01)
	assert_almost_eq(tower.shooter.bullet_speed, speed, 0.01)

func test_body_entered_GivenPlayer_KeepsReference_DisconnectsBodyEntered_ConnectsBodyExited() -> void:
	# Given
	var player : Player = autofree(Player.new())
	var tower : Tower = autofree(Tower.new())
	tower.player_detector = autofree(DetectionZone.new())
	tower.player_detector.body_entered.connect(tower.body_entered)
	
	# When
	tower.body_entered(player)
	
	# Then
	assert_eq(tower.player, player)
	assert_eq(tower.player_detector.body_entered.get_connections().size(), 0)
	assert_eq(tower.player_detector.body_exited.get_connections().size(), 1)

