extends Area2D

var is_player_in: bool = false
var health: int = 3
var height = -8  # altura do tronco, sem contar a copa
const SOURCE_ID = 0  # ID do seu TileSet (normalmente 0)
const TRONCO_ATLAS = Vector2i(0, 5) # coord do tile do tronco no atlas
const COPA_ATLAS = Vector2i(1, 5)   # coord do tile da copa no atlas


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("brake_tree") and is_player_in:
		chop()
	
	if health <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	is_player_in = true


func _on_body_exited(body: Node2D) -> void:
	is_player_in = false


func chop():
	if height == 0:
		queue_free()
		return

	# 1. Remover o tile mais baixo
	$TileMapLayer.set_cell(Vector2i(0, height - 1), -1)

	# 2. Descer todos os blocos do tronco
	for y in range(height - 1, 0, -1):
		var tile = $TileMapLayer.get_cell_source_id(Vector2i(0, y))
		var atlas = $TileMapLayer.get_cell_atlas_coords(Vector2i(0, y))
		if tile != -1:
			$TileMapLayer.set_cell(Vector2i(0, y - 1), tile, atlas)
			$TileMapLayer.set_cell(Vector2i(0, y), -1)

	# 3. Recolocar a copa no novo topo
	$TileMapLayer.set_cell(Vector2i(0, height - 1), SOURCE_ID, COPA_ATLAS)

	# diminuir a altura do tronco
	height += 1
