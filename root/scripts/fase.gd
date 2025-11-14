class_name Fase
extends Node2D

signal causar_dano(quantidade: int)
signal finalizar_fase
signal reiniciar_fase

@onready var player: Node = $Player
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var game_over_screen: CanvasLayer = $GameOverScreen

var num_fase: int = 1
var dados_fase: Dictionary = {}
var mob_atual: Node = null
var boss_atual: Node = null

var mapas: Array[Resource] = [
	preload("res://root/scenes/scene/game_scene/game_content/mapas/Mapa1.tscn"),
	preload("res://root/scenes/scene/game_scene/game_content/mapas/Mapa2.tscn"),
	preload("res://root/scenes/scene/game_scene/game_content/mapas/Mapa3.tscn"),
	preload("res://root/scenes/scene/game_scene/game_content/mapas/Mapa4.tscn"),
	preload("res://root/scenes/scene/game_scene/game_content/mapas/Mapa5.tscn")
]

var arquivos_perguntas: Array[String] = [
	"res://root/fases/fase1.json",
	"res://root/fases/fase2.json",
	"res://root/fases/fase3.json",
	"res://root/fases/fase4.json",
	"res://root/fases/fase5.json"
]

var _mapa_atual = null


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('game_pause'):
		print('esc')
		get_tree().paused = true


func _carregar_dados_fase() -> void:

	var path_arquivo_perguntas: String = arquivos_perguntas[num_fase-1]
	var file := FileAccess.open(path_arquivo_perguntas, FileAccess.READ)
	var content: String = file.get_as_text()
	file.close()

	var json := JSON.new()
	json.parse(content)
	dados_fase = json.get_data()


func _iniciar_mapa() -> void:
	_mapa_atual = mapas[num_fase-1].instantiate()


func _posicionar_jogador() -> void:
	var ponto_inicial := get_node_or_null("PlayerStart")
	if ponto_inicial and is_instance_valid(player):
		player.global_position = ponto_inicial.global_position


func _configurar_mobs() -> void:
	var mobs := $Map/Mobs.get_children()
	for i in range(mobs.size()):
		var mob := mobs[i]
		var node_pergunta := mob.get_node("Pergunta")
		node_pergunta.configurar(dados_fase["texto_perguntas"][i])
		
		node_pergunta.resposta_selecionada.connect(_on_mob_alternativa_selecionada)
		
		mob.deve_fazer_pergunta.connect(_on_mob_responder_pergunta)


# Configura o boss com suas perguntas do arquivo de dados.
func _configurar_boss() -> void:
	var boss := $Boss

	var perguntas_boss := boss.get_node("Perguntas").get_children()
	var textos_boss = dados_fase["texto_perguntas_boss"]

	for i in range(perguntas_boss.size()):
		var node_pergunta := perguntas_boss[i]
		node_pergunta.configurar(textos_boss[i])
		
		if not node_pergunta.resposta_selecionada.is_connected(_on_boss_alternativa_selecionada):
			node_pergunta.resposta_selecionada.connect(_on_boss_alternativa_selecionada)
		if not boss.deve_fazer_pergunta_boss.is_connected(_on_boss_responder_pergunta_boss):
			boss.deve_fazer_pergunta_boss.connect(_on_boss_responder_pergunta_boss)


func init() -> void:
	
	_carregar_dados_fase()
	_iniciar_mapa()
	_posicionar_jogador()
	_configurar_mobs()
	_configurar_boss()
	_connect_signals()


func set_fase(num_fase: int) -> void:
	assert(num_fase >= 1 and num_fase <= 5)
	self.num_fase = num_fase


func _on_game_pause_menu_button() -> void:
	get_tree().paused = true
	LogWrapper.debug(name, "Game paused.")


func _on_continue_menu_button() -> void:
	pause_menu.visible = false
	get_tree().paused = false
	LogWrapper.debug(name, "Game unpaused.")


func _on_options_menu_button() -> void:
	pause_menu.visible = false


func _on_options_back_menu_button() -> void:
	pause_menu.visible = true


func _on_leave_menu_button() -> void:
	pause_menu.visible = false
	get_tree().paused = false
	LogWrapper.debug(name, "Game leave.")

	self.process_mode = PROCESS_MODE_DISABLED
	Data.exit_save_file()


func _on_quit_menu_button() -> void:
	Data.save_save_file()
	get_tree().quit()


func _connect_signals() -> void:
	
	pause_menu.continue_menu_button.confirmed.connect(_on_continue_menu_button)
	pause_menu.options_menu_button.confirmed.connect(_on_options_menu_button)
	pause_menu.leave_menu_button.confirmed.connect(_on_leave_menu_button)
	pause_menu.quit_menu_button.confirmed.connect(_on_quit_menu_button)
	

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
