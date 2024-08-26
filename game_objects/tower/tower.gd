extends Damageable
class_name Tower

var player : Player

@onready var player_detector : DetectionZone = $DetectionZone as DetectionZone
@onready var timer : Timer = $Timer
@onready var shooter : Shooter = $Shooter

func initialize(tower_spawn_request : TowerSpawnRequest) -> void:
	player_detector.body_entered.connect(body_entered)
	timer.wait_time = tower_spawn_request.shot_cooldown_seconds
	shooter.bullet_damage = tower_spawn_request.damage
	health = tower_spawn_request.health
	body_entered(player_detector.get_player())

func body_entered(body : Node3D) -> void:
	if body is Player:
		player = body as Player
		player_detector.body_entered.disconnect(body_entered)
		player_detector.body_exited.connect(body_exited)
		set_physics_process(true)

func body_exited(body : Node3D) -> void:
	if body is Player:
		player = null
		player_detector.body_entered.connect(body_entered)
		player_detector.body_exited.disconnect(body_exited)
		set_physics_process(false)

func _physics_process(delta):
	if timer.is_stopped():
		shoot()
		timer.start()

func shoot() -> void:
	shooter.shoot(player.global_position - global_position)
