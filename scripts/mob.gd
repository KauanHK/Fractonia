extends Area2D

signal responder_pergunta


func _on_body_entered(body: Node2D) -> void:
	for botao in $Pergunta.get_node('Alternativas').get_children():
		print(botao.disabled)
		botao.disabled = false
	
	responder_pergunta.emit(self)
