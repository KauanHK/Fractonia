extends CanvasLayer

class_name PerguntaUI

signal resposta_selecionada(foi_correta: bool)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_pergunta: Label = $Text
@onready var alternativas_container: Node = $Alternativas

# Guarda os dados da pergunta atual (texto, alternativas, etc.)
var dados_atuais: Dictionary = {}
var indice_correto_atual: int = -1


func configurar(dados_da_pergunta: Dictionary) -> void:
	dados_atuais = dados_da_pergunta
	label_pergunta.text = str(dados_atuais["pergunta"])

	var botoes = alternativas_container.get_children()
	var alternativas = dados_atuais["alternativas"]

	# Cria lista com texto e índice original, embaralha e aplica aos botões
	var items: Array = []
	for j in range(alternativas.size()):
		items.append({"text": str(alternativas[j]), "orig": j})

	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in range(items.size()):
		var j := rng.randi_range(0, items.size()-1)
		var tmp = items[i]
		items[i] = items[j]
		items[j] = tmp

	# Preenche botões e encontra onde ficou a alternativa original de índice 0 (correta)
	indice_correto_atual = -1
	for i in range(botoes.size()):
		var botao = botoes[i]
		if i >= items.size():
			botao.text = ""
			continue
		
		botao.text = items[i]["text"]
		if items[i]["orig"] == 0:
			indice_correto_atual = i

		# Conecta o sinal de cada botão ao callback atual
		if not botao.button_down.is_connected(Callable(self, "_on_resposta_selecionada")):
			botao.button_down.connect(Callable(self, "_on_resposta_selecionada").bind(i))


func ask() -> void:
	show()
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().paused = true


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
