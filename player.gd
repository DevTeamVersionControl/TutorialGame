class_name Player
extends CharacterBody3D

const SPEED = 5.0
const DECELERATION = 1
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
const MIN_X_ROTATION_DEGREES = -40
const MAX_X_ROTATION_DEGREES = 60
const MIN_Y_WORLD_POSITION = -10

const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08
var t_bob = 0.0

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var tree # For testing purposes

@onready var head_x : Node3D = $Head_X
@onready var head_y : Node3D = $Head_X/Head_Y
@onready var camera : Camera3D = $Head_X/Head_Y/Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	tree = get_tree()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head_x.rotate_y(-event.relative.x * SENSITIVITY)
		head_y.rotate_x(-event.relative.y * SENSITIVITY)
		head_y.rotation.x = clamp(head_y.rotation.x, deg_to_rad(MIN_X_ROTATION_DEGREES), deg_to_rad(MAX_X_ROTATION_DEGREES))

func _physics_process(delta):
	if enforce_world_boundaries(global_position):
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		set_jump_velocity()
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	set_movement_velocity(input_dir)
	
	add_head_bob(delta, is_on_floor())
	
	move_and_slide()

func set_movement_velocity(input_dir : Vector2) -> void:
	var direction = (head_x.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

func set_jump_velocity() -> void:
	velocity.y = JUMP_VELOCITY

func add_head_bob(delta : float, on_floor : bool) -> void:
	t_bob += delta * velocity.length() * float(on_floor)
	camera.transform.origin = Vector3(0, sin(t_bob * BOB_FREQUENCY) * BOB_AMPLITUDE, 0)

func enforce_world_boundaries(player_position : Vector3) -> bool:
	var in_world_boundaries := player_position.y > MIN_Y_WORLD_POSITION
	if not in_world_boundaries:
		tree.reload_current_scene()
	return not in_world_boundaries
