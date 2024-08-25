extends GutTest

func test_initialise_payload_HappyPath_SetsToFirstPoint() -> void:
	# Given
	var values = setup_test_scene()
	var payload : Payload = values["payload"]
	var path : Path3D = values["path"]
	payload.can_advance = true
	
	# When
	payload.initialise_payload()
	# Then
	assert_almost_eq(payload.global_position, path.global_position + path.curve.get_point_in(0), Vector3.ONE * 0.01)
#
func test_follow_line_HappyPath_FollowsPath() -> void:
	# Given
	var values = setup_test_scene()
	var payload : Payload = values["payload"]
	var path : Path3D = values["path"]
	payload.speed = 1.0
	
	var time = 1.0
	# When
	payload.follow_line(time)
	await wait_frames(1)
	# Then
	assert_eq(payload.progress, 1.0)
	var target_position = path.global_position + path.curve.get_point_position(1)
	assert_almost_eq(payload.global_position, target_position, Vector3.ONE * 0.01)

func test_follow_line_WhenNegativeSpeed_GoesBackwards() -> void:
	# Given
	var values = setup_test_scene()
	var payload : Payload = values["payload"]
	var path : Path3D = values["path"]
	payload.speed = 1.0
	
	var time = 1.0
	# When
	payload.follow_line(time)
	await wait_frames(1)
	payload.speed = -1.0
	payload.follow_line(time)
	await wait_frames(1)
	
	# Then
	assert_almost_eq(payload.progress, 0.0, 0.1)
	var target_position = path.global_position + path.curve.get_point_position(0)
	assert_almost_eq(payload.global_position, target_position, Vector3.ONE * 0.1)

func test_update_speed_WhenCanNotAdvance_ReducesSpeed() -> void:
	# Given
	var values = setup_test_scene()
	var payload : Payload = values["payload"]
	payload.can_advance = false
	payload.speed = 1.0
	payload.acceleration = 0.5
	
	var time = 1.0
	# When
	payload.update_speed(time)
	
	# Then
	assert_almost_eq(payload.speed, 0.5, 0.01)

func test_follow_line_WhenGetsToLastPoint_ReloadsLevel() -> void:
	# Given
	var values = setup_test_scene()
	var payload : Payload = values["payload"]
	payload.tree = autofree(double(SceneTree).new())
	payload.can_advance = true
	payload.speed = 1.0
	payload.progress_ratio = 0.95
	var time = 1.0
	# When
	payload.follow_line(time)
	await wait_frames(1)
	
	# Then
	assert_called(payload.tree, 'reload_current_scene')

func test_update_can_advance_WhenPlayerIsInZone_SetsTrue() -> void:
	## Given
	var values = setup_test_scene()
	var payload : Payload = values["payload"]
	# When
	payload.update_can_advance()
	# Then
	assert_true(payload.can_advance)

func test_update_can_advance_WhenPlayerIsNotInZone_SetsFalse() -> void:
	## Given
	var values = setup_test_scene()
	var payload : Payload = values["payload"]
	payload.can_advance = true
	
	var player : Player = values["player"]
	player.global_position = Vector3(10,0,10)
	# When
	payload.update_can_advance()
	# Then
	assert_false(payload.can_advance)

func setup_test_scene() -> Dictionary:
	var player = preload("res://game_objects/player/player.tscn").instantiate()
	var payload = preload("res://game_objects/payload/payload.tscn").instantiate()
	payload.player = player
	add_child_autofree(player)
	player.axis_lock_linear_y = true
	var path = Path3D.new()
	path.curve = Curve3D.new()
	path.curve.add_point(Vector3(0, 0, 0))
	path.curve.add_point(Vector3(2, 0, 2).normalized())
	path.curve.add_point(Vector3(10, 0, 10))
	path.add_child(payload)
	add_child_autofree(path)
	return {"payload":payload, "player":player, "path":path}
