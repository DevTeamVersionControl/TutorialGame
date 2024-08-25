extends GutTest

const player_scene = preload("res://player/player.tscn")
var _sender = InputSender.new(Input)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_shoot_WhenPressingLeftMouse_Shoots() -> void:
	# Given
	var player : Player = player_scene.instantiate()
	add_child_autofree(player)
	player.shooter = autofree(double(Shooter).new())
	player.add_child(player.shooter)
	
	var timer : Timer = player.get_node("BulletCooldownTimer")
	
	# When
	player.shoot()
	
	# Then
	assert_false(timer.is_stopped())
	assert_called(player.shooter, "shoot")

func test_shoot_WhenShootingTwiceBeforeCooldown_ShootsOnlyOnce() -> void:
	# Given
	var player : Player = player_scene.instantiate()
	add_child_autofree(player)
	player.shooter = autofree(double(Shooter).new())
	player.add_child(player.shooter)
	
	var timer : Timer = player.get_node("BulletCooldownTimer")
	
	# When
	player.shoot()
	await wait_frames(1)
	player.shoot()
	
	# Then
	assert_false(timer.is_stopped())
	assert_call_count(player.shooter, "shoot", 1)

func test_shoot_WhenCooldownIsOver_CanShootAgain() -> void:
	# Given
	var player : Player = player_scene.instantiate()
	add_child_autofree(player)
	
	player.shooter = autofree(double(Shooter).new())
	player.add_child(player.shooter)
	
	var timer : Timer = player.get_node("BulletCooldownTimer")
	timer.wait_time = 0.1
	
	# When
	player.shoot()
	await wait_seconds(0.2)
	player.shoot()
	
	# Then
	assert_false(timer.is_stopped())
	assert_call_count(player.shooter, "shoot", 2)
