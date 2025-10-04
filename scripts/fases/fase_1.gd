extends Node2D

@onready var player = $Player
@onready var mobs = $Map/Mobs.get_children()

var mob_atual = null

var texto_alternativas = [
	{
		"pergunta": "Pergunta teste",
		"alternativas": [
			"Teste1",
			"Teste2",
			"Teste3",
		]
	},
	{
		"pergunta": "Pergunta teste 2",
		"alternativas": [
			"Teste12",
			"Teste22",
			"Teste32",
		]
	},
	{
		"pergunta": "Pergunta teste3",
		"alternativas": [
			"Teste13",
			"Teste23",
			"Teste33",
		]
	}
]

signal causar_dano
signal finalizar_fase
signal reiniciar_fase

func _ready() -> void:
	
	# Coloca o jogador na posição inicial definida no mapa
	var ponto_inicial = get_node_or_null("PlayerStart")
	if ponto_inicial:
		player.global_position = ponto_inicial.global_position
	
	var alternativas = get_tree().get_nodes_in_group("alternativas")
	for alternativa in alternativas:
		alternativa.alternativa_selecionada.connect(_on_alternativa_selecionada)
	
	var mobs = $Map/Mobs.get_children()
	for i in range(len(mobs)):
		var mob = mobs[i]
		var textos_pergunta = texto_alternativas[i]
		var node_pergunta = mob.get_node('Pergunta')
		node_pergunta.texto_pergunta = textos_pergunta["pergunta"]
		node_pergunta.texto_alternativa1 = textos_pergunta["alternativas"][0]
		node_pergunta.texto_alternativa2 = textos_pergunta["alternativas"][1]
		node_pergunta.texto_alternativa3 = textos_pergunta["alternativas"][2]
		node_pergunta.update()


func _on_mob_responder_pergunta(mob) -> void:
	mob_atual = mob
	mob_atual.get_node('Pergunta').show()
	get_tree().paused = true


func _on_alternativa_selecionada(resposta_correta: bool) -> void:
	if resposta_correta:
		mob_atual.queue_free()
		get_tree().paused = false
		return
	causar_dano.emit(30)


func _on_player_game_over() -> void:
	if mob_atual:
		mob_atual.get_node('Pergunta').hide()
	$GameOverScreen.show()


func _on_game_over_screen_voltar_menu() -> void:
	finalizar_fase.emit()
	queue_free()


func _on_game_over_screen_reiniciar_fase() -> void:
	reiniciar_fase.emit()
