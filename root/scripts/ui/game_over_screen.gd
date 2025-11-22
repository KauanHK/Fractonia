class_name GameOverScreen
extends CanvasLayer

@onready var restart_button: MenuButtonClass = %RestartButton
@onready var menu_button: MenuButtonClass = %MenuButton

signal reiniciar_fase
signal voltar_menu


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	restart_button.button_down.connect(_on_restart_button_down)
	menu_button.button_down.connect(_on_menu_button_down)


func _on_restart_button_down() -> void:
	reiniciar_fase.emit()


func _on_menu_button_down() -> void:
	voltar_menu.emit()
