extends Node

var min_bounds : Vector3
var max_bounds : Vector3
var seconds_in_level : float
var level : int

func _ready():
	min_bounds = Vector3(-12, -7, 32)
	max_bounds = Vector3(37, 13, -35) 
	level = 0
