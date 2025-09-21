extends Area2D

@export var resposta_correta: bool

signal selecionou_alternativa

func _on_body_entered(body: Node2D) -> void:
	selecionou_alternativa.emit(resposta_correta)
