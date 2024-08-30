extends Node

const PLAYER_SCENE : PackedScene = preload("res://game_objects/player/player.tscn")
const TOWER_SCENE : PackedScene = preload("res://game_objects/tower/tower.tscn")
const BULLET_SCENE : PackedScene = preload("res://game_objects/bullet/bullet.tscn")
const PAYLOAD_SCENE : PackedScene = preload("res://game_objects/payload/payload.tscn")

const TEST_BULLET_SCENE : PackedScene = preload("res://test/test_bullet_scene.tscn")

const MAIN_LEVEL_SCENE : PackedScene = preload("res://scenes/main_scene.tscn")
const LEVEL_END_MENU_SCENE : PackedScene = preload("res://scenes/menus/level_end_menu/level_end_menu.tscn")
