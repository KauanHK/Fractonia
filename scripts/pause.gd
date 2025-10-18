extends CanvasLayer

signal pause
signal pause_button_pressed

func _on_continuar_pressed() -> void:
	pause_button_pressed.emit('continuar')


func _on_menu_pressed() -> void:
	pause_button_pressed.emit('menu')


func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed('toggle_pause'):
		pause.emit()
