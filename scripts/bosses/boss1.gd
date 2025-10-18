extends Area2D

signal responder_pergunta_boss
signal death_boss

@onready var nodes_perguntas = $Perguntas.get_children()

var pergunta_atual = null
var index_pergunta_atual = null

func _on_body_entered(body: Node2D) -> void:
	responder_pergunta()


func proxima_pergunta() -> void:
	
	index_pergunta_atual += 1
	if index_pergunta_atual >= len(nodes_perguntas):
		death_boss.emit()
		queue_free()
		return
	
	responder_pergunta()


func responder_pergunta() -> void:
	
	if index_pergunta_atual:
		pergunta_atual.hide()
		await pergunta_atual.fade_out()
	else:
		index_pergunta_atual = 0
	
	pergunta_atual = nodes_perguntas[index_pergunta_atual]
	pergunta_atual.show()
	pergunta_atual.fade_in()
	responder_pergunta_boss.emit(self)


func morte_jogador() -> void:
	pergunta_atual.hide()
