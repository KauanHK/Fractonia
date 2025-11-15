class_name Mob
extends Area2D

signal fazer_pergunta(mob: Mob)

@onready var pergunta: PerguntaUI = $Pergunta
@onready var animation_player: AnimationPlayer = $Pergunta/AnimationPlayer


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body) -> void:
	fazer_pergunta.emit(self)


func fade_out() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
