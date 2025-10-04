extends CanvasLayer

signal reiniciar_fase
signal voltar_menu

func _on_restart_button_button_down() -> void:
	reiniciar_fase.emit()


func _on_menu_button_button_down() -> void:
	voltar_menu.emit()
