#extends GutTest
#
#const player_scene = preload("res://player.tscn")
#var _sender = InputSender.new(Input)
#
#func after_each():
	#_sender.release_all()
	#_sender.clear()
#
#func test__physics_process_WhenHeadStraight_MovesForwardsCorrectly() -> void:
	## Given
	#var player : Player = player_scene.instantiate()
	#add_child_autofree(player)
	#var expected_velocity := Vector3.FORWARD
	#
	## When
	#_sender.action_down("move_forwards").wait_frames(1)
	#await(_sender.idle)
	#
	## Then
	#assert_eq(player.velocity.normalized(), expected_velocity)
#
#func test__physics_process_WhenHeadRotated_MovesForwardsCorrectly() -> void:
	## Given
	#var player : Player = player_scene.instantiate()
	#add_child_autofree(player)
	#player.head_x.rotate_y(PI/2)
	#var expected_velocity := Vector3.FORWARD.rotated(Vector3.UP, PI/2)
	#
	## When
	#_sender.action_down("move_forwards").wait_frames(1)
	#await(_sender.idle)
	#
	## Then
	#assert_eq(player.velocity.normalized(), expected_velocity)
