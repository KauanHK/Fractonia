extends Area2D

@onready var pergunta = $Pergunta
var is_player_in: bool = false

signal responder_pergunta


func _process(delta: float) -> void:
	if is_player_in and Input.is_action_just_pressed("interact"):
		pergunta.get_node('AnimationPlayer').play('fade_in')
		responder_pergunta.emit(self)


func _on_body_entered(body: Node2D) -> void:
	is_player_in = true


func _on_body_exited(body: Node2D) -> void:
	is_player_in = false


func fade_out() -> void:
	pergunta.fade_out()
