extends CanvasLayer

class_name HealthBar

@export var maxHealth: int = 100
@export var health: int = 100

signal death

@onready var health_bar: ProgressBar = $HealthBar
@onready var damager_bar: ProgressBar = $HealthBar/DamageBar
@onready var timer: Timer = $HealthBar/Timer


func _ready() -> void:
	health_bar.value = maxHealth
	damager_bar.value = maxHealth
	_connect_signals()


func _connect_signals() -> void:
	timer.timeout.connect(_on_timeout)


func _on_timeout() -> void:
	damager_bar.value = health_bar.value


func update() -> void:
	if maxHealth == 0:
		return
	health_bar.value = int(health * 100 / maxHealth)
	if health <= 0:
		emit_signal("death")
	
	timer.start()


func causar_dano(damage: int) -> void:
	health = max(0, health - damage)
	update()
