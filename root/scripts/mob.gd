class_name Mob
extends Control

signal fazer_pergunta(mob: Mob)

@onready var pergunta: PerguntaUI = $Pergunta
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)


func _on_body_entered(_body) -> void:
	fazer_pergunta.emit(self)
