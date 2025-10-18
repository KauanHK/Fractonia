extends CanvasLayer

# Este sinal é emitido para a cena da fase quando uma resposta é escolhida.
signal resposta_selecionada(foi_correta)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_pergunta: Label = $Text
@onready var alternativas_container = $Alternativas

# Guarda os dados da pergunta atual (texto, alternativas, etc.)
var dados_atuais: Dictionary


func configurar(dados_da_pergunta: Dictionary):
	dados_atuais = dados_da_pergunta
	label_pergunta.text = dados_atuais["pergunta"]
	
	var botoes = alternativas_container.get_children()
	for i in range(botoes.size()):
		var botao = botoes[i]
		botao.text = dados_atuais["alternativas"][i]
		# Conecta o sinal de cada botão a uma função interna deste script.
		# O .bind() é usado para passar o índice do botão que foi pressionado.
		if not botao.pressed.is_connected(_on_botao_alternativa_pressionado):
			botao.pressed.connect(_on_botao_alternativa_pressionado.bind(i))


func ask():
	self.show()
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().paused = true


func _on_botao_alternativa_pressionado(indice_do_botao: int):
	print('ok')
	# A resposta correta é a alternativa no índice 0 por padrão (pode ser ajustado)
	var foi_correta = (indice_do_botao == 0)

	# Despausa o jogo imediatamente.
	get_tree().paused = false
	
	# Emite o sinal para avisar a cena da fase sobre o resultado.
	resposta_selecionada.emit(foi_correta)

	# Inicia a animação de fade-out e esconde a UI quando terminar.
	animation_player.play("fade_out")
	await animation_player.animation_finished
	self.hide()
