class_name Alternativa
extends Button

signal alternativa_selecionada(alternativa: Alternativa)

var alternativa_correta: bool = false


func _ready() -> void:
	_connect_signals()


func set_alternativa_correta(alternativa_correta: bool) -> void:
	self.alternativa_correta = alternativa_correta


func _connect_signals() -> void:
	button_down.connect(_on_button_down)


func _on_button_down() -> void:
	alternativa_selecionada.emit(self)
