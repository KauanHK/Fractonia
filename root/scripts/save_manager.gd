extends Node

# O caminho do nosso arquivo de save. Usar "user://" é crucial!
const CAMINHO_SAVE: String = "user://progresso.json"

# Um dicionário que vai guardar todos os dados do jogo enquanto ele está rodando.
var dados_do_jogo: Dictionary = {}


func _ready() -> void:
	carregar_jogo()


func carregar_jogo() -> void:
	if not FileAccess.file_exists(CAMINHO_SAVE):
		dados_do_jogo = {
			"fase_atual": 1,
			"moedas": 0,
		}
		return

	var arquivo := FileAccess.open(CAMINHO_SAVE, FileAccess.READ)
	if arquivo == null:
		dados_do_jogo = {"fase_atual": 1, "moedas": 0}
		return

	var conteudo_json: String = arquivo.get_as_text()
	arquivo.close()
	var parse_result = JSON.parse_string(conteudo_json)
	if typeof(parse_result) == TYPE_DICTIONARY:
		dados_do_jogo = parse_result
	else:
		# fallback
		dados_do_jogo = {"fase_atual": 1, "moedas": 0}


func salvar_jogo() -> void:
	var arquivo := FileAccess.open(CAMINHO_SAVE, FileAccess.WRITE)
	if arquivo == null:
		push_error("Não foi possível abrir arquivo de save para escrita: %s" % CAMINHO_SAVE)
		return
	var json_como_texto: String = JSON.stringify(dados_do_jogo, "\t")
	arquivo.store_string(json_como_texto)
	arquivo.close()
