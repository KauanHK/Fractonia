class_name Mob
extends Area2D

@onready var pergunta: PerguntaUI = $Pergunta
@onready var animation_player: AnimationPlayer = $Pergunta/AnimationPlayer


func fade_out() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
