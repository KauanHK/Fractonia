extends Area2D

@export var resposta_correta = false
signal selecionou_alternativa

func _on_body_entered(body: Node2D) -> void:
	print('ok')
	selecionou_alternativa.emit(resposta_correta)
