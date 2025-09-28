extends CanvasLayer


func update(player) -> void:
	$ProgressBar.value = player.currentHealth * 100 / player.maxHealth


func _on_player_health_changed(player) -> void:
	update(player)
