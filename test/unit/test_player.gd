extends GutTest

func test_enforce_world_boundaries_WhenInsideBoundaries_DoesntReload() -> void:
	# Given
	var player : Player = autofree(Player.new())
	var position := Vector3(0, 0, 0)
	var tree_double : SceneTree = autofree(double(SceneTree).new())
	stub(tree_double, 'reload_current_scene').to_do_nothing()
	player.tree = tree_double
	
	# When
	var result := player.enforce_world_boundaries(position)
	
	# Then 
	assert_false(result)
	assert_not_called(tree_double, 'reload_current_scene')

func test_enforce_world_boundaries_WhenOutsideBoundaries_Reloads() -> void:
	# Given
	var player : Player = autofree(Player.new())
	var position := Vector3(0, Player.MIN_Y_WORLD_POSITION-1, 0)
	var tree_double : SceneTree = autofree(double(SceneTree).new())
	stub(tree_double, 'reload_current_scene').to_do_nothing()
	player.tree = tree_double
	
	# When
	var result := player.enforce_world_boundaries(position)
	
	# Then 
	assert_true(result)
	assert_called(tree_double, 'reload_current_scene')

func test_set_movement_velocity_WhenHeadStraight_MovesForwardsCorrectly() -> void:
	# Given
	var player : Player = autofree(Player.new())
	var input_vector := Vector2.UP
	player.head_x = autofree(Node3D.new())
	
	# When
	player.set_movement_velocity(input_vector)
	
	# Then 
	assert_eq(player.velocity.normalized(), Vector3.FORWARD)

func test_set_movement_velocity_WhenHeadTurned_MovesForwardsCorrectly() -> void:
	# Given
	var player : Player = autofree(Player.new())
	var input_vector := Vector2.UP
	player.head_x = autofree(Node3D.new())
	
	var angles := [0, PI/6, PI/3, PI/2, PI, 2*PI, -PI]
	for angle in angles:
		player.head_x.rotate_y(angle)
		# When
		player.set_movement_velocity(input_vector)
		# Then 
		assert_almost_eq(player.velocity.normalized(), Vector3.FORWARD.rotated(Vector3.UP, angle), Vector3.ONE*0.01)
		player.head_x.rotate_y(-angle)

func test_set_jump_velocity_HappyPath_SetsMaxJumpSpeed() -> void:
	# Given
	var player : Player = autofree(Player.new())
	
	# When
	player.set_jump_velocity()
	
	# Then 
	assert_eq(player.velocity.y, player.JUMP_VELOCITY)

func test_add_head_bob_HappyPath_FollowsCurve() -> void:
	# Given
	var player : Player = autofree(Player.new())
	var is_on_floor := true
	var delta := 1
	player.velocity = Vector3(1, 0, 1).normalized()
	player.camera = autofree(Camera3D.new())
	# When
	player.add_head_bob(delta, is_on_floor)
	# Then 
	assert_almost_eq(player.camera.transform.origin.y, sin(delta * player.BOB_FREQUENCY)*player.BOB_AMPLITUDE, 0.01)

func test_add_head_bob_WithHighSpeed_GoesQuicker() -> void:
	# Given
	var player : Player = autofree(Player.new())
	var is_on_floor := true
	var delta := 1.0
	player.velocity = Vector3(10, 0, 10)
	player.camera = autofree(Camera3D.new())
	# When
	player.add_head_bob(delta, is_on_floor)
	# Then 
	assert_almost_eq(player.camera.transform.origin.y, sin(delta * player.BOB_FREQUENCY*player.velocity.length())*player.BOB_AMPLITUDE, 0.01)

func test_add_head_bob_WhenNotTouchingGround_DoesNothing() -> void:
	# Given
	var player : Player = autofree(Player.new())
	var is_on_floor := false
	var delta := 1.0
	player.velocity = Vector3(10, 0, 10)
	player.camera = autofree(Camera3D.new())
	# When
	player.add_head_bob(delta, is_on_floor)
	# Then 
	assert_almost_eq(player.camera.transform.origin.y, 0.0, 0.01)

func test_add_head_bob_WhenCalledSeveralTimes_ContinuesCurve() -> void:
	# Given
	var player : Player = autofree(Player.new())
	var is_on_floor := true
	var delta := 1
	player.velocity = Vector3(10, 0, 10)
	player.camera = autofree(Camera3D.new())
	# When
	player.add_head_bob(delta, is_on_floor)
	player.add_head_bob(delta, is_on_floor)
	# Then 
	assert_almost_eq(player.camera.transform.origin.y, sin(2 * delta * player.BOB_FREQUENCY*player.velocity.length())*player.BOB_AMPLITUDE, 0.01)

func test_add_head_bob_WhenCalledAtDifferentFrameRates_IsEquivalent() -> void:
	# Given
	var is_on_floor := true
	var delta := 1
	# Player 1
	var player1 : Player = autofree(Player.new())
	player1.velocity = Vector3(10, 0, 10)
	player1.camera = autofree(Camera3D.new())
	# Player 2
	var player2 : Player = autofree(Player.new())
	player2.velocity = Vector3(10, 0, 10)
	player2.camera = autofree(Camera3D.new())
	# When
	player1.add_head_bob(delta, is_on_floor)
	player2.add_head_bob(delta*0.5, is_on_floor)
	player2.add_head_bob(delta*0.5, is_on_floor)
	# Then 
	assert_almost_eq(player1.camera.transform.origin.y, player2.camera.transform.origin.y, 0.01)
