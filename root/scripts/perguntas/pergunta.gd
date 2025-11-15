class_name PerguntaUI
extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_pergunta: Label = $Text
@onready var alternativas: Array[Alternativa]

# Guarda os dados da pergunta atual (texto, alternativas, etc.)
var dados_atuais: Dictionary
var indice_correto_atual: int = -1


func _ready() -> void:
	_carregar_alternativas()


func configurar(dados_da_pergunta: Dictionary) -> void:

	dados_atuais = dados_da_pergunta
	alternativas[0].set_alternativa_correta(true)

	_definir_texto_pergunta(dados_atuais['pergunta'])
	var items: Array = dados_atuais['alternativas']
	_randomizar(items)

	var i = 0
	for alternativa: Alternativa in alternativas:
		if i >= items.size():
			alternativa.text = ""
			continue
		alternativa.text = items[i]
		alternativa.button_down.connect(_on_resposta_selecionada.bind(alternativa))
		i += 1


func ask() -> void:
	show()
	animation_player.play("fade_in")
	await animation_player.animation_finished


func _carregar_alternativas() -> void:
	for node_alternativa: Alternativa in $Alternativas.get_children():
		alternativas.append(node_alternativa)


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


func _on_resposta_selecionada(index: int) -> void:
	
	var resposta_correta: bool = (index == indice_correto_atual)
	resposta_selecionada.emit(resposta_correta)
	
	if not resposta_correta:
		return
	
	# Inicia a animação de fade-out e esconde a UI quando terminar.
	animation_player.play("fade_out")
	await animation_player.animation_finished
	hide()
