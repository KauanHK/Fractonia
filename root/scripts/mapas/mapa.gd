class_name Mapa
extends Node2D

@onready var node_mobs: Node2D = %Mobs
@onready var mobs: Array = %Mobs.get_children()


func _configurar_mobs(texto_perguntas) -> void:
	for i in range(mobs.size()):
		var mob: Mob = mobs[i]
		var node_pergunta: PerguntaUI = mob.get_node("Pergunta")
		node_pergunta.configurar(texto_perguntas[i])
		
		node_pergunta.resposta_selecionada.connect(_on_mob_alternativa_selecionada)
		
		mob.deve_fazer_pergunta.connect(_on_mob_responder_pergunta)
