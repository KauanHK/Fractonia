extends Button

@export var resposta_correta: bool

signal alternativa_selecionada


func _on_button_down() -> void:
	alternativa_selecionada.emit(resposta_correta)
