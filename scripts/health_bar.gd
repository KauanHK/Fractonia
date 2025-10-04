extends CanvasLayer

@export var maxHealth: int
@export var health: int

signal death

func update() -> void:
	$ProgressBar.value = health * 100 / maxHealth
	if health <= 0:
		death.emit()


func causar_dano(damage: int) -> void:
	health -= damage
	update()
