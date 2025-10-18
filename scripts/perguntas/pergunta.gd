extends CanvasLayer

@export var texto_pergunta: String
@export var texto_alternativa1: String
@export var texto_alternativa2: String
@export var texto_alternativa3: String
@export var alternativa_correta: int = 1

@onready var animation_player = $AnimationPlayer
@onready var alternativas = [
	$Alternativas/Alternativa1,
	$Alternativas/Alternativa2,
	$Alternativas/Alternativa3
]


func _ready() -> void:
	update()


func update() -> void:
	
	var textos_alternativas = [
		texto_alternativa1,
		texto_alternativa2,
		texto_alternativa3
	]
	
	$Text.text = texto_pergunta
	
	for i in range(len(alternativas)):
		alternativas[i].get_node('Label').text = textos_alternativas[i];
	
	alternativas[alternativa_correta-1].resposta_correta = true


func fade_in() -> void:
	animation_player.play('fade_in')
	await animation_player.animation_finished



func fade_out() -> void:
	animation_player.play('fade_out')
	await animation_player.animation_finished
