extends Node2D

var label_vidas
var vidas = 3

signal open_menu

func _ready():
	
	# Armazena o node do label do número de vidas
	label_vidas = $Vidas
	
	# Conecta o signal 'selecionou_alternativa'
	var todas_as_alternativas = get_tree().get_nodes_in_group("alternativas")
	for alternativa in todas_as_alternativas:
		alternativa.selecionou_alternativa.connect(_on_alternativa_selecionada)


func _on_alternativa_selecionada(alternativa_correta) -> void:
	if alternativa_correta:
		return
		
	vidas -= 1
	label_vidas.text = "Vidas: " + str(vidas)
	
	if is_game_over():
		game_over()


func game_over() -> void:
	get_tree().paused = true
	$GameOverScreen.show()


func is_game_over() -> bool:
	return vidas <= 0


func _on_pause() -> void:
	var is_paused = not get_tree().paused
	$Pause.visible = is_paused
	get_tree().paused = is_paused


func _on_pause_button_pressed(acao_botao: String) -> void:
	$Pause.hide()
	
	if acao_botao == 'continuar':
		get_tree().paused = false
		return
	
	if acao_botao == 'menu':
		queue_free()
		open_menu.emit()


func _on_mob_responder_pergunta() -> void:
	$Node2D/Mob/CanvasLayer/Pergunta.show()
