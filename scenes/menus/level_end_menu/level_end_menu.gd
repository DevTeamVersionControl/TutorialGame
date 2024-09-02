class_name LevelEndMenu extends Control

@onready var exit_button : Button = $ExitButton
@onready var next_level_button : Button = $NextLevelButton
@onready var time_label : Label = $HBoxContainer/VBoxContainer/TimeLabel
@onready var level_finished_label : Label = $HBoxContainer/VBoxContainer/LevelFinishedLabel
var level_system : LevelSystem
var tree

func _ready():
	level_system = LevelSystemSingleton if level_system == null else level_system
	tree = get_tree() if tree == null else tree
	
	exit_button.pressed.connect(exit_game)
	next_level_button.pressed.connect(load_next_level)
	time_label.text = time_convert(GlobalVars.seconds_in_level)
	level_finished_label.text = "LEVEL {0} FINISHED !".format([level_system.level])
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func exit_game() -> void:
	tree.quit()

func load_next_level() -> void:
	level_system.increase_level()
	tree.change_scene_to_packed(RessourceMappings.MAIN_LEVEL_SCENE)

func time_convert(time_in_sec : float) -> String:
	var milliseconds = (time_in_sec - int(time_in_sec)) * 100
	var seconds = int(time_in_sec)%60
	var minutes = int(time_in_sec/60)%60
	var hours = int(time_in_sec/60/60)
	
	return "%02d:%02d:%02d.%02d" % [hours, minutes, seconds, milliseconds]
