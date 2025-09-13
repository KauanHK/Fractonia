extends Label

var vidas = 3

func _selecionou_alternativa(alternativa_correta: bool) -> void:
	vidas -= int(alternativa_correta)
	text = "Vidas: " + str(vidas)
