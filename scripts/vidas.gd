extends Label

var vidas = 3


func _on_alternativa_selecionou_alternativa(alternativa_correta) -> void:
	print('ok')
	vidas -= int(alternativa_correta)
	text = "Vidas: " + str(vidas)
