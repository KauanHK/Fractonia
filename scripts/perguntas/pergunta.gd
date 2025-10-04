extends CanvasLayer

@export var texto_pergunta: String
@export var texto_alternativa1: String
@export var texto_alternativa2: String
@export var texto_alternativa3: String
@export var alternativa_correta: int = 1

@onready var alternativas = [
	$Alternativas/Alternativa1,
	$Alternativas/Alternativa2,
	$Alternativas/Alternativa3
]

func _ready() -> void:
	hide()
	
	$Text.text = texto_pergunta
	
	var textos_alternativas = [
		texto_alternativa1,
		texto_alternativa2,
		texto_alternativa3
	]
	
	for i in range(len(alternativas)):
		alternativas[i].text = textos_alternativas[i];
	
	alternativas[alternativa_correta-1].resposta_correta = true
