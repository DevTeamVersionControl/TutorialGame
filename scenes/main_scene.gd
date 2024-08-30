class_name MainScene extends Node3D

@export var test_tower_spot : TowerSpot

@onready var payload : Payload = %Payload
@onready var player : Player = %Player
@onready var tower_spot_parent = $TowerSpots
@onready var hud : Hud = $HUD

var start_level_time_msec : int
var level_system : LevelSystem
var tree

func _ready():
	tree = get_tree() if tree == null else tree
	level_system = LevelSystemSingleton if level_system == null else level_system
	level_system.new_level(tower_spot_parent)
	
	payload.payload_finished.connect(end_level)
	player.took_damage.connect(hud.set_health_count)
	
	hud.set_health_count(player.health)
	hud.set_level_count(level_system.level)
	
	start_level_time_msec = Time.get_ticks_msec()

func end_level() -> void:
	GlobalVars.seconds_in_level = float(Time.get_ticks_msec() - start_level_time_msec)/1000
	tree.change_scene_to_packed(RessourceMappings.LEVEL_END_MENU_SCENE)
