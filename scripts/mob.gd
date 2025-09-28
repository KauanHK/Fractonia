extends Area2D

signal responder_pergunta
signal causar_dano


func _on_body_entered(body: Node2D) -> void:
	$Pergunta.show()
	responder_pergunta.emit()


func _ready() -> void:
	
	var alternativas = get_tree().get_nodes_in_group("alternativas")
	for alternativa in alternativas:
		alternativa.alternativa_selecionada.connect(_on_alternativa_selecionada)


func _on_alternativa_selecionada(alternativa_correta: bool) -> void:
	causar_dano.emit(alternativa_correta)
