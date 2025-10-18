extends Area2D

signal deve_fazer_pergunta(mob)

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fade_out():
	animation_player.play("fade_out")
	await animation_player.animation_finished


func _on_body_entered(body):
	deve_fazer_pergunta.emit(self)
	$CollisionShape2D.set_deferred("disabled", true)
