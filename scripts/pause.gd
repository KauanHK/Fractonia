extends CanvasLayer

class_name PauseUI

signal pause
signal pause_button_pressed(action: String)

func _on_continuar_pressed() -> void:
	emit_signal("pause_button_pressed", "continuar")


func _on_menu_pressed() -> void:
	emit_signal("pause_button_pressed", "menu")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('toggle_pause'):
		emit_signal("pause")
