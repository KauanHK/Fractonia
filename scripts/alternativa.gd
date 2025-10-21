extends Button

class_name Alternativa

@export var resposta_correta: bool = false

signal alternativa_selecionada(foi_correta: bool)


func _on_button_down() -> void:
	disabled = true
	emit_signal("alternativa_selecionada", resposta_correta)
