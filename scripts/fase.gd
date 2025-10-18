extends Node2D

# --- SINAIS ---
# Sinais que esta fase emite para se comunicar com o jogo principal (ex: um nó "GameManager")
signal causar_dano(quantidade)
signal finalizar_fase
signal reiniciar_fase

# --- EXPORTS ---
# Cria um campo no Inspetor para arrastar o arquivo JSON específico desta fase.
# Usar @export_file garante que você só possa selecionar arquivos com a extensão .json.
@export_file("*.json") var arquivo_de_perguntas: String

# --- REFERÊNCIAS DE NÓS ---
@onready var player = $Player
@onready var game_over_screen = $GameOverScreen

# --- VARIÁVEIS DA FASE ---
# Dicionário que irá armazenar os dados carregados do arquivo JSON.
var dados_da_fase: Dictionary

# Variáveis para rastrear o inimigo ou boss com o qual o jogador está interagindo.
var mob_atual = null
var boss_atual = null


func _ready() -> void:
	# A primeira coisa a fazer é carregar os dados. Se falhar, a fase não continua.
	_carregar_dados_da_fase()
	if dados_da_fase.is_empty():
		return # Interrompe a execução se os dados não foram carregados.

	_posicionar_jogador()
	_configurar_mobs()
	_configurar_boss()


#-----------------------------------------------------------------------------
# SEÇÃO DE CONFIGURAÇÃO INICIAL (CHAMADA PELO _ready)
#-----------------------------------------------------------------------------

# Carrega e interpreta (parse) o arquivo JSON definido no Inspetor.
func _carregar_dados_da_fase() -> void:
	if arquivo_de_perguntas.is_empty():
		print("ERRO: Nenhum arquivo de perguntas JSON foi definido no Inspetor para esta fase.")
		return

	var file = FileAccess.open(arquivo_de_perguntas, FileAccess.READ)
	if not file:
		print("ERRO: Não foi possível abrir o arquivo: ", arquivo_de_perguntas)
		return

	var content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		print("ERRO: Falha ao interpretar o arquivo JSON. Erro: ", json.get_error_message(), " na linha ", json.get_error_line())
		return

	dados_da_fase = json.get_data()
	print("Dados da fase carregados com sucesso de: ", arquivo_de_perguntas)


# Posiciona o jogador no ponto inicial definido no mapa.
func _posicionar_jogador() -> void:
	var ponto_inicial = get_node_or_null("PlayerStart")
	if ponto_inicial:
		player.global_position = ponto_inicial.global_position


func _configurar_mobs() -> void:
	var mobs = $Map/Mobs.get_children()
	for i in range(len(mobs)):
		var mob = mobs[i]
		var textos_pergunta = dados_da_fase["texto_perguntas"][i]
		var node_pergunta = mob.get_node('Pergunta')
		
		print('node_pergunta.resposta_selecionada.connect(_on_mob_alternativa_selecionada)')
		node_pergunta.resposta_selecionada.connect(_on_mob_alternativa_selecionada)
		
		node_pergunta.configurar(textos_pergunta)
		mob.deve_fazer_pergunta.connect(_on_mob_responder_pergunta)


# Configura o boss com suas perguntas do arquivo de dados.
func _configurar_boss() -> void:
	var boss = $Boss
	var perguntas_boss = boss.get_node('Perguntas').get_children()
	
	for i in range(len(perguntas_boss)):
		var textos_pergunta = dados_da_fase["texto_perguntas_boss"][i]
		var node_pergunta = perguntas_boss[i]

		node_pergunta.configurar(textos_pergunta)
		
		for node_alternativa in node_pergunta.get_node('Alternativas').get_children():
			node_alternativa.alternativa_selecionada.connect(_on_boss_alternativa_selecionada)


#-----------------------------------------------------------------------------
# SEÇÃO DE LÓGICA DE COMBATE E PERGUNTAS
#-----------------------------------------------------------------------------

func _on_mob_responder_pergunta(mob) -> void:
	mob_atual = mob
	mob_atual.get_node('Pergunta').ask() # Assume que 'ask' controla a animação e pausa.


func _on_mob_alternativa_selecionada(resposta_correta: bool) -> void:
	print(resposta_correta)
	if resposta_correta:
		await mob_atual.fade_out() # Animação de morte do mob.
		mob_atual.queue_free()
		get_tree().paused = false
	else:
		causar_dano.emit(10)


func _on_boss_responder_pergunta_boss(boss) -> void:
	boss_atual = boss
	boss_atual.death_boss.connect(_on_boss_death_boss)
	# A lógica de pausa e exibição da pergunta deve ser controlada pelo próprio boss.


func _on_boss_alternativa_selecionada(resposta_correta: bool) -> void:
	if resposta_correta:
		boss_atual.proxima_pergunta()
	else:
		causar_dano.emit(20)


#-----------------------------------------------------------------------------
# SEÇÃO DE ESTADO DO JOGO (GAME OVER, VITÓRIA)
#-----------------------------------------------------------------------------

func _on_player_game_over() -> void:
	# Garante que as telas de pergunta sejam escondidas se o jogador morrer durante uma.
	if mob_atual:
		mob_atual.get_node('Pergunta').hide()
	if boss_atual:
		boss_atual.morte_jogador()
	
	game_over_screen.show()


func _on_game_over_screen_voltar_menu() -> void:
	finalizar_fase.emit()
	queue_free() # Destrói a cena da fase ao voltar para o menu.


func _on_game_over_screen_reiniciar_fase() -> void:
	reiniciar_fase.emit()


func _on_boss_death_boss() -> void:
	# Lógica para salvar o progresso e desbloquear a próxima fase.
	var fase_atual = SaveManager.dados_do_jogo["fase_atual"]
	if fase_atual <= 2: # Esta lógica talvez precise ser ajustada.
		SaveManager.dados_do_jogo["fase_atual"] = 3
		SaveManager.salvar_jogo()
	
	finalizar_fase.emit()
	queue_free()
