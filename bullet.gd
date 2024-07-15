class_name Bullet
extends Area3D

var direction := Vector3(1, 0, 0)
var speed := 5.0
var damage := 0.0

func initialize(new_direction : Vector3, new_damage : float, new_speed : float) -> void:
	if new_direction.is_normalized():
		direction = new_direction
	else:
		direction = new_direction.normalized()
	global_transform = global_transform.looking_at(new_direction+global_position)
	damage = new_damage
	speed = new_speed

func _physics_process(delta : float) -> void:
	global_position += speed * delta * direction
	enforce_world_boundaries(GlobalVars.min_bounds, GlobalVars.max_bounds)

func enforce_world_boundaries(world_min : Vector3, world_max : Vector3) -> void:
	if global_position != clamp(global_position, world_min, world_max):
		queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage, direction)
	queue_free()
