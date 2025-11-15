class_name PerguntaUI
extends CanvasLayer


signal resposta_selecionada(foi_correta: bool)

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
	_definir_texto_pergunta(dados_atuais['pergunta'])
	var items: Array = _mapear_conteudo_alternativas(dados_atuais['alternativas'])
	_randomizar(items)

	# Preenche botões e encontra onde ficou a alternativa original de índice 0 (correta)
	indice_correto_atual = -1
	for i in range(alternativas.size()):
		var alternativa: Alternativa = alternativas[i]
		if i >= items.size():
			alternativa.text = ""
			continue

		alternativa.text = items[i]["text"]
		if items[i]["orig"] == 0:
			indice_correto_atual = i

		# Conecta o sinal de cada botão ao callback atual
		if not alternativa.button_down.is_connected(Callable(self, "_on_resposta_selecionada")):
			alternativa.button_down.connect(Callable(self, "_on_resposta_selecionada").bind(i))


func ask() -> void:
	show()
	animation_player.play("fade_in")
	await animation_player.animation_finished


func _carregar_alternativas() -> void:
	for node_alternativa: Alternativa in $Alternativas.get_children():
		alternativas.append(node_alternativa)


func _definir_texto_pergunta(text: String) -> void:
	label_pergunta.text = text


func _mapear_conteudo_alternativas(alternativas: Array) -> Array:
	var items: Array = []
	for j in range(alternativas.size()):
		items.append({"text": alternativas[j], "orig": j})
	return items


func _randomizar(items: Array) -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in range(items.size()):
		var j := rng.randi_range(0, items.size()-1)
		var tmp = items[i]
		items[i] = items[j]
		items[j] = tmp


func _on_resposta_selecionada(index: int) -> void:
	
	var resposta_correta = (index == indice_correto_atual)
	
	# Emite o sinal para avisar a cena da fase sobre o resultado.
	emit_signal("resposta_selecionada", resposta_correta)
	
	if not resposta_correta:
		return
	
	get_tree().paused = false
	# Inicia a animação de fade-out e esconde a UI quando terminar.
	animation_player.play("fade_out")
	await animation_player.animation_finished
	hide()
