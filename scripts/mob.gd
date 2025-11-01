extends Area2D

class_name Mob

signal deve_fazer_pergunta(mob: Node)

@onready var animation_player: AnimationPlayer = $Pergunta/AnimationPlayer


func fade_out() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished


func _on_body_entered(_body: Node) -> void:
	emit_signal("deve_fazer_pergunta", self)
	$CollisionShape2D.set_deferred("disabled", true)
