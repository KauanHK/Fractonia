class_name Mob
extends Area2D

signal fazer_pergunta(mob: Mob)

@onready var pergunta: PerguntaUI = $Pergunta


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body) -> void:
	fazer_pergunta.emit(self)
