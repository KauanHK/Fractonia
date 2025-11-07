class_name Fase
extends Node2D

signal causar_dano(quantidade: int)
signal finalizar_fase
signal reiniciar_fase

@export_file("*.json") var arquivo_de_perguntas: String = ""
@export var num_fase: int = 1

@onready var player: Node = $Player
@onready var game_over_screen: CanvasLayer = $GameOverScreen

var dados_da_fase: Dictionary = {}

var mob_atual: Node = null
var boss_atual: Node = null


const dados_fases = [
	{
	  "texto_perguntas": [
		{
		  "pergunta": "Pergunta 1 da Fase 1",
		  "alternativas": [
			"Alternativa 1.1",
			"Alternativa 1.2",
			"Alternativa 1.3"
		  ]
		},
		{
		  "pergunta": "Pergunta 2 da Fase 1",
		  "alternativas": [
			"Alternativa 2.1",
			"Alternativa 2.2",
			"Alternativa 2.3"
		  ]
		},
		{
		  "pergunta": "Pergunta 3 da Fase 1",
		  "alternativas": [
			"Alternativa 3.1",
			"Alternativa 3.2",
			"Alternativa 3.3"
		  ]
		}
	  ],
	  "texto_perguntas_boss": [
		{
		  "pergunta": "Pergunta do boss 1 da Fase 1",
		  "alternativas": [
			"Alternativa 1.1",
			"Alternativa 1.2",
			"Alternativa 1.3"
		  ]
		},
		{
		  "pergunta": "Pergunta do boss 2 da Fase 1",
		  "alternativas": [
			"Alternativa 2.1",
			"Alternativa 2.2",
			"Alternativa 2.3"
		  ]
		},
		{
		  "pergunta": "Pergunta do boss 3 da Fase 1",
		  "alternativas": [
			"Alternativa 3.1",
			"Alternativa 3.2",
			"Alternativa 3.3"
		  ]
		}
	  ]
	}
]


func _ready() -> void:
	_carregar_dados_da_fase()
	_posicionar_jogador()
	_configurar_mobs()
	_configurar_boss()


func _carregar_dados_da_fase() -> void:
	
	#var file := FileAccess.open(arquivo_de_perguntas, FileAccess.READ)
	#
	#var content: String = file.get_as_text()
	#file.close()
	#
	#var json := JSON.new()
	#var err := json.parse(content)
	
	#dados_da_fase = json.get_data()
	
	dados_da_fase = dados_fases[num_fase-1]
	print('ok')
	print(dados_da_fase)


# Posiciona o jogador no ponto inicial definido no mapa.
func _posicionar_jogador() -> void:
	var ponto_inicial := get_node_or_null("PlayerStart")
	if ponto_inicial and is_instance_valid(player):
		player.global_position = ponto_inicial.global_position


func _configurar_mobs() -> void:
	var mobs := $Map/Mobs.get_children()
	for i in range(mobs.size()):
		var mob := mobs[i]
		var node_pergunta := mob.get_node("Pergunta")
		node_pergunta.configurar(dados_da_fase["texto_perguntas"][i])
		
		node_pergunta.resposta_selecionada.connect(_on_mob_alternativa_selecionada)
		
		mob.deve_fazer_pergunta.connect(_on_mob_responder_pergunta)


# Configura o boss com suas perguntas do arquivo de dados.
func _configurar_boss() -> void:
	var boss := $Boss

	var perguntas_boss := boss.get_node("Perguntas").get_children()
	var textos_boss = dados_da_fase["texto_perguntas_boss"]

	for i in range(perguntas_boss.size()):
		print(i)
		var node_pergunta := perguntas_boss[i]
		node_pergunta.configurar(textos_boss[i])
		
		node_pergunta.resposta_selecionada.connect(_on_boss_alternativa_selecionada)
		boss.deve_fazer_pergunta_boss.connect(_on_boss_responder_pergunta_boss)


#-----------------------------------------------------------------------------
# SEÇÃO DE LÓGICA DE COMBATE E PERGUNTAS
#-----------------------------------------------------------------------------

func _on_mob_responder_pergunta(mob: Node) -> void:
	mob_atual = mob
	if is_instance_valid(mob_atual):
		mob_atual.get_node("Pergunta").ask() # Assume que 'ask' controla a animação e pausa.


func _on_mob_alternativa_selecionada(resposta_correta: bool) -> void:
	if resposta_correta and is_instance_valid(mob_atual):
		await mob_atual.fade_out()
		mob_atual.queue_free()
		get_tree().paused = false
	else:
		causar_dano.emit(10)


func _on_boss_responder_pergunta_boss(boss: Node) -> void:
	boss_atual = boss
	boss_atual.death_boss.connect(_on_boss_death_boss)


func _on_boss_alternativa_selecionada(resposta_correta: bool) -> void:
	if resposta_correta and is_instance_valid(boss_atual):
		boss_atual.proxima_pergunta()
	else:
		causar_dano.emit(20)


#-----------------------------------------------------------------------------
# SEÇÃO DE ESTADO DO JOGO (GAME OVER, VITÓRIA)
#-----------------------------------------------------------------------------

func _on_player_game_over() -> void:
	# Garante que as telas de pergunta sejam escondidas se o jogador morrer durante uma.
	if is_instance_valid(mob_atual):
		mob_atual.get_node("Pergunta").hide()
	if is_instance_valid(boss_atual):
		boss_atual.morte_jogador()

	if is_instance_valid(game_over_screen):
		game_over_screen.show()


func _on_game_over_screen_voltar_menu() -> void:
	finalizar_fase.emit()
	queue_free() # Destrói a cena da fase ao voltar para o menu.


func _on_game_over_screen_reiniciar_fase() -> void:
	reiniciar_fase.emit()


func _on_boss_death_boss() -> void:
	# Lógica para salvar o progresso e desbloquear a próxima fase.
	var fase_atual = SaveManager.dados_do_jogo.get("fase_atual", 1)
	if fase_atual <= num_fase:
		SaveManager.dados_do_jogo["fase_atual"] = num_fase + 1
		SaveManager.salvar_jogo()

	finalizar_fase.emit()
	queue_free()
