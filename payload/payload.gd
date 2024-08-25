class_name Payload
extends PathFollow3D

var can_advance := false
var block := false
var tree # For testing purposes
@export var player : Player
@export var speed : float = 0
@export var max_speed : float = 1.0
@export var acceleration := 0.5

@onready var path : Path3D = get_parent()
@onready var detection_zone : MeshInstance3D = $DetectionZone

func _ready():
	tree = get_tree()

func initialise_payload() -> void:
	progress = 0

func follow_line(delta_time : float) -> void:
	var new_progress := progress + speed * delta_time
	if new_progress >= path.curve.get_baked_length():
		tree.reload_current_scene()
	elif new_progress < 0:
		return
	progress = new_progress

func _physics_process(delta):
	update_can_advance()
	if not block:
		update_speed(delta)
		follow_line(delta)

func update_can_advance() -> void:
	var new_can_advance : bool = (player.global_position - global_position).length() <= detection_zone.mesh.radius
	can_advance = new_can_advance

func update_speed(delta_time : float) -> void:
	var new_speed = speed + acceleration * delta_time * (1.0 if can_advance else -1.0)
	speed = clamp(new_speed, -max_speed/4, max_speed)
