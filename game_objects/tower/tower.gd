extends Damageable
class_name Tower

var player : Player

@onready var player_detector : DetectionZone = $DetectionZone as DetectionZone
@onready var timer : Timer = $Timer
@onready var shooter : Shooter = $Shooter

func initialize(tower_spawn_request : TowerSpawnRequest) -> void:
	shooter.bullet_damage = tower_spawn_request.bullet_damage
	shooter.bullet_speed = tower_spawn_request.bullet_speed
	health = tower_spawn_request.health
	
	player_detector.body_entered.connect(body_entered)
	
	timer.start(0.05) # Buffer so that tower doesn't shoot player if they moved out on the first frame
	timer.wait_time = tower_spawn_request.shot_cooldown_seconds

func body_entered(body : Node3D) -> void:
	if body is Player:
		player = body as Player
		player_detector.body_entered.disconnect(body_entered)
		player_detector.body_exited.connect(body_exited)

func body_exited(body : Node3D) -> void:
	if body is Player:
		player = null
		player_detector.body_entered.connect(body_entered)
		player_detector.body_exited.disconnect(body_exited)

func _physics_process(_delta):
	if player != null and timer.is_stopped():
		shoot()
		timer.start()

func shoot() -> void:
	shooter.shoot(player.target.global_position - shooter.global_position)
