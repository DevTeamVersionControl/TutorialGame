extends GutTest

func before_each():
	GlobalVars._ready()

func test_AccuratelyMeasuresTime() -> void:
	# Given
	var scene : MainScene = RessourceMappings.MAIN_LEVEL_SCENE.instantiate()
	var tree_double = autofree(double(SceneTree).new()) # To avoid changing scenes and breaking tests
	# When
	add_child_autofree(scene)
	scene.tree = tree_double
	await wait_seconds(1)
	scene.end_level()
	# Then
	assert_almost_eq(GlobalVars.seconds_in_level, 1, 0.2)

func test_DifferentTimeScale_TimeMeasuredUnaffected() -> void:
	# Given
	var scene : MainScene = RessourceMappings.MAIN_LEVEL_SCENE.instantiate()
	var tree_double = autofree(double(SceneTree).new()) # To avoid changing scenes and breaking tests
	Engine.time_scale = 2
	# When
	add_child_autofree(scene)
	scene.tree = tree_double
	await wait_seconds(1 * Engine.time_scale) # Turns out this is affected by time scale lol
	scene.end_level()
	# Then
	assert_almost_eq(GlobalVars.seconds_in_level, 1, 0.2)
	Engine.time_scale = 1
