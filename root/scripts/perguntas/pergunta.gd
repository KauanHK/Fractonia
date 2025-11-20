class_name PerguntaUI
extends Control

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var label_pergunta: Label = %Text
@onready var alternativas: Array[Alternativa] = _carregar_alternativas()

# Guarda os dados da pergunta atual (texto, alternativas, etc.)
var dados_atuais: Dictionary
var indice_correto_atual: int = -1

signal alternativa_selecionada(alternativa: Alternativa)


func configurar(dados_da_pergunta: Dictionary) -> void:

	dados_atuais = dados_da_pergunta

	_definir_texto_pergunta(dados_atuais['pergunta'])
	var texto_alternativas: Array = dados_atuais['alternativas']
	_randomizar(alternativas)
	alternativas[0].set_alternativa_correta(true)

	var i = 0
	for alternativa: Alternativa in alternativas:
		alternativa.text = texto_alternativas[i]
		i += 1


func ask() -> void:
	await fade_in()
	show()


func fade_in() -> void:
	return
	animation_player.play("fade_in")
	await animation_player.animation_finished


func fade_out() -> void:
	return
	animation_player.play("fade_out")
	await animation_player.animation_finished


func _carregar_alternativas() -> Array[Alternativa]:
	var nodes_alternativa: Array[Alternativa] = []
	for node_alternativa: Alternativa in %AlternativasContainer.get_children():
		nodes_alternativa.append(node_alternativa)
	return nodes_alternativa

func _definir_texto_pergunta(text: String) -> void:
	label_pergunta.text = text


func _randomizar(items: Array) -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in range(items.size()):
		var j := rng.randi_range(0, items.size()-1)
		var tmp = items[i]
		items[i] = items[j]
		items[j] = tmp


func _connect_signals() -> void:
	for alternativa: Alternativa in alternativas:
		alternativa.alternativa_selecionada.connect(_on_alternativa_selecionada)


func _on_alternativa_selecionada(alternativa: Alternativa) -> void:
	alternativa_selecionada.emit(alternativa)
