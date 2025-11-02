extends Area2D

class_name TreeNode

func _on_body_entered(body: Node2D) -> void:
	print("entered")


func _on_body_exited(body: Node2D) -> void:
	print("exited")
