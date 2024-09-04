extends GutTest

func before_each():
	GlobalVars._ready()

func test_ClickExitButton_TriesToQuitGame() -> void:
	# Given
	var level_end_menu : LevelEndMenu = RessourceMappings.LEVEL_END_MENU_SCENE.instantiate()
	add_child_autofree(level_end_menu)
	var tree_double = autofree(double(SceneTree).new())
	level_end_menu.tree = tree_double
	# When
	level_end_menu.exit_button.pressed.emit()
	# Then
	assert_called(tree_double, "quit")

func test_ClickNextButton_ChangesSceneAndIncreasesLevel() -> void:
	# Given
	var level_end_menu : LevelEndMenu = RessourceMappings.LEVEL_END_MENU_SCENE.instantiate()
	add_child_autofree(level_end_menu)
	var tree_double = autofree(double(SceneTree).new())
	level_end_menu.tree = tree_double
	var level_system_double : LevelSystem = autofree(double(LevelSystem).new())
	level_end_menu.level_system = level_system_double
	# When
	level_end_menu.next_level_button.pressed.emit()
	# Then
	assert_called(level_system_double, "increase_level")
	assert_called(tree_double, "change_scene_to_packed")

func test_ConvertsTimeProperly() -> void:
	# Given
	GlobalVars.seconds_in_level = 99999.99
	# When
	var level_end_menu : LevelEndMenu = RessourceMappings.LEVEL_END_MENU_SCENE.instantiate()
	add_child_autofree(level_end_menu)
	# Then
	assert_eq(level_end_menu.time_label.text, "27:46:39.99")
