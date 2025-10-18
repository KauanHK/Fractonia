extends Node2D

@onready var player = $Player
@onready var mobs = $Map/Mobs.get_children()

var mob_atual = null
var boss_atual = null

var texto_perguntas = [
	{
		"pergunta": "Pergunta teste fase 2",
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

var texto_perguntas_boss = [
	{
		"pergunta": "Pergunta do boss",
		"alternativas": [
			"teste boss1 1",
			"teste boss1 2",
			"teste boss1 3"
		]
	},
	{
		"pergunta": "Pergunta do boss 2",
		"alternativas": [
			"teste boss1 4",
			"teste boss1 5",
			"teste boss1 6"
		]
	},
	{
		"pergunta": "Pergunta do boss 3",
		"alternativas": [
			"teste boss1 7",
			"teste boss1 8",
			"teste boss1 9"
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
	
	var mobs = $Map/Mobs.get_children()
	for i in range(len(mobs)):
		var mob = mobs[i]
		var textos_pergunta = texto_perguntas[i]
		var node_pergunta = mob.get_node('Pergunta')
		node_pergunta.texto_pergunta = textos_pergunta["pergunta"]
		node_pergunta.texto_alternativa1 = textos_pergunta["alternativas"][0]
		node_pergunta.texto_alternativa2 = textos_pergunta["alternativas"][1]
		node_pergunta.texto_alternativa3 = textos_pergunta["alternativas"][2]
		node_pergunta.update()
		
		for node_alternativa in node_pergunta.get_node('Alternativas').get_children():
			node_alternativa.alternativa_selecionada.connect(_on_mob_alternativa_selecionada)
	
	var boss = $Boss
	var perguntas_boss = boss.get_node('Perguntas').get_children()
	
	for i in range(len(perguntas_boss)):
		var textos_pergunta = texto_perguntas_boss[i]
		var node_pergunta = perguntas_boss[i]
		node_pergunta.texto_pergunta = textos_pergunta["pergunta"]
		node_pergunta.texto_alternativa1 = textos_pergunta["alternativas"][0]
		node_pergunta.texto_alternativa2 = textos_pergunta["alternativas"][1]
		node_pergunta.texto_alternativa3 = textos_pergunta["alternativas"][2]
		node_pergunta.update()
		
		for node_alternativa in node_pergunta.get_node('Alternativas').get_children():
			node_alternativa.alternativa_selecionada.connect(_on_boss_alternativa_selecionada)


func _on_mob_responder_pergunta(mob) -> void:
	mob_atual = mob
	mob_atual.get_node('Pergunta').show()
	get_tree().paused = true


func _on_mob_alternativa_selecionada(resposta_correta: bool) -> void:
	if resposta_correta:
		await mob_atual.fade_out()
		mob_atual.queue_free()
		get_tree().paused = false
		return
	causar_dano.emit(10)


func _on_player_game_over() -> void:
	if mob_atual:
		mob_atual.get_node('Pergunta').hide()
	if boss_atual:
		boss_atual.morte_jogador()
	$GameOverScreen.show()


func _on_game_over_screen_voltar_menu() -> void:
	finalizar_fase.emit()
	queue_free()


func _on_game_over_screen_reiniciar_fase() -> void:
	reiniciar_fase.emit()


func _on_boss_responder_pergunta_boss(boss) -> void:
	boss_atual = boss
	boss_atual.death_boss.connect(_on_boss_death_boss)
	get_tree().paused = true


func _on_boss_alternativa_selecionada(resposta_correta: bool) -> void:
	if resposta_correta:
		boss_atual.proxima_pergunta()
		return
	causar_dano.emit(20)


func _on_boss_death_boss() -> void:
	var fase_atual = SaveManager.dados_do_jogo["fase_atual"]
	if fase_atual <= 2:
		SaveManager.dados_do_jogo["fase_atual"] = 3
		SaveManager.salvar_jogo()
	
	finalizar_fase.emit()
	queue_free()
