class_name MainScene extends Node3D

@export var test_tower_spot : TowerSpot
@onready var payload : Payload = %Payload
var start_level_time_msec : int
var tree

func _ready():
	if test_tower_spot != null:
		test_tower_spot.spawn_tower(TowerSpawnRequest.new(50, 2, 10, 5))
	payload.payload_finished.connect(end_level)
	tree = get_tree()
	start_level_time_msec = Time.get_ticks_msec()

func end_level() -> void:
	GlobalVars.seconds_in_level = float(Time.get_ticks_msec() - start_level_time_msec)/1000
	tree.change_scene_to_packed(RessourceMappings.LEVEL_END_MENU_SCENE)
