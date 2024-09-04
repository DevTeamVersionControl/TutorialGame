class_name Hud extends CanvasLayer

@onready var health_count_label : Label = $Health/HealthCount
@onready var level_count_label : Label = $Level/LevelCount

func set_health_count(health : float) -> void:
	health_count_label.text = str(int(health))

func set_level_count(level : int) -> void:
	level_count_label.text = str(level)
