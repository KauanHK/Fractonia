extends CanvasLayer

class_name GameOverScreen

signal reiniciar_fase
signal voltar_menu

func _on_restart_button_button_down() -> void:
	emit_signal("reiniciar_fase")


func _on_menu_button_button_down() -> void:
	emit_signal("voltar_menu")
