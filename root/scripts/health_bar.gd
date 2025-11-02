extends CanvasLayer

class_name HealthBar

@export var maxHealth: int = 100
@export var health: int = 100

signal death

@onready var progress_bar: ProgressBar = $ProgressBar

func update() -> void:
	if maxHealth == 0:
		return
	if is_instance_valid(progress_bar):
		progress_bar.value = int(health * 100 / maxHealth)
	if health <= 0:
		emit_signal("death")


func causar_dano(damage: int) -> void:
	health = max(0, health - damage)
	update()
