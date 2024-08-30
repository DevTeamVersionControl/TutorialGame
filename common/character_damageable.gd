extends CharacterBody3D
class_name CharacterDamageable

signal took_damage

var material : StandardMaterial3D
var mesh_instance : MeshInstance3D

@export var damage_animation_decay_seconds := 0.2
@export var health := 50.0

func _ready() -> void:
	mesh_instance = get_node_or_null("MeshInstance3D")
	if mesh_instance:
		material = StandardMaterial3D.new()
		mesh_instance.set_surface_override_material(0, material)

func take_damage(damage : float, _direction : Vector3) -> void:
	if damage < 0.0:
		push_error("Tried to deal negative damage")
		return
	took_damage.emit()
	
	health -= damage
	if health <= 0.0:
		die()
		return
	
	if mesh_instance:
		material.albedo_color = Color.RED
		var tween := create_tween()
		tween.tween_property(material, "albedo_color", Color.WHITE, 
				damage_animation_decay_seconds).set_trans(Tween.TRANS_SINE)

func die() -> void:
	queue_free()
