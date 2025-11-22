class_name Fase
extends Node2D

signal causar_dano(quantidade: int)
signal finalizar_fase
signal reiniciar_fase

@onready var player: Player = $Player
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var game_over_screen: CanvasLayer = $GameOverScreen

var num_fase: int = 1
var dados_fase: Dictionary
var mob_atual: Mob
var boss: Boss

var _mapa_atual: Mapa

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


func _ready() -> void:
	_connect_signals()


func init() -> void:
	_carregar_dados_fase()
	_iniciar_mapa()
	_connect_mobs_signals()
	_connect_boss_signals()


func set_fase(num_fase: int) -> void:
	assert(num_fase >= 1 and num_fase <= 5)
	self.num_fase = num_fase


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('game_pause'):
		pause_menu.visible = true
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
	add_child(_mapa_atual)
	
	_mapa_atual.posicionar_jogador(player)
	_mapa_atual.configurar_boss(dados_fase["texto_perguntas_boss"])
	_mapa_atual.configurar_mobs(dados_fase["texto_perguntas"])
	
	boss = _mapa_atual.boss


func _on_game_pause_menu_button() -> void:
	get_tree().paused = true


func _on_continue_menu_button() -> void:
	pause_menu.visible = false
	get_tree().paused = false


func _on_options_menu_button() -> void:
	pause_menu.visible = false


func _on_options_back_menu_button() -> void:
	pause_menu.visible = true


func _on_quit_menu_button() -> void:
	get_tree().quit()


func _connect_signals() -> void:

	pause_menu.continue_menu_button.confirmed.connect(_on_continue_menu_button)
	pause_menu.options_menu_button.confirmed.connect(_on_options_menu_button)
	pause_menu.quit_menu_button.confirmed.connect(_on_quit_menu_button)


func _connect_mobs_signals() -> void:
	for mob: Mob in _mapa_atual.mobs:
		mob.fazer_pergunta.connect(_on_fazer_pergunta)
		for alternativa: Alternativa in mob.pergunta.alternativas:
			alternativa.alternativa_selecionada.connect(_on_alternativa_selecionada)


func _connect_boss_signals() -> void:
	boss.iniciar_batalha.connect(_on_boss_iniciar_batalha)
	boss.morte.connect(_on_boss_death_boss)
	for pergunta: PerguntaUI in boss.perguntas:
		for alternativa: Alternativa in pergunta.alternativas:
			alternativa.alternativa_selecionada.connect(_on_boss_alternativa_selecionada)


func _on_fazer_pergunta(mob: Mob) -> void:
	mob_atual = mob
	get_tree().paused = true
	mob_atual.pergunta.visible = true
	mob_atual.pergunta.ask()


func _on_alternativa_selecionada(alternativa: Alternativa) -> void:

	if not alternativa.alternativa_correta:
		causar_dano.emit(10)
		return

	await mob_atual.pergunta.fade_out()
	mob_atual.queue_free()
	
	SaveManager.dados_do_jogo["moedas"] += 100
	SaveManager.salvar_jogo()
	
	get_tree().paused = false
	return


func _on_boss_iniciar_batalha() -> void:
	get_tree().paused = true
	boss.proxima_pergunta()


func _on_boss_alternativa_selecionada(alternativa: Alternativa) -> void:
	if alternativa.alternativa_correta:
		boss.proxima_pergunta()
		return
	causar_dano.emit(20)


func _on_player_game_over() -> void:
	mob_atual.pergunta.queue_free()
	game_over_screen.show()


func _on_game_over_screen_voltar_menu() -> void:
	finalizar_fase.emit()


func _on_game_over_screen_reiniciar_fase() -> void:
	reiniciar_fase.emit()


func _on_boss_death_boss() -> void:

	var fase_atual = SaveManager.dados_do_jogo.get("fase_atual", 1)
	if fase_atual <= num_fase:
		SaveManager.dados_do_jogo["fase_atual"] = num_fase + 1
		SaveManager.salvar_jogo()
	
	get_tree().paused = false
	finalizar_fase.emit()
