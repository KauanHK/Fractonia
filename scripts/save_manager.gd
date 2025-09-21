extends Node

# O caminho do nosso arquivo de save. Usar "user://" é crucial!
const CAMINHO_SAVE = "user://progresso.json"

# Um dicionário que vai guardar todos os dados do jogo enquanto ele está rodando.
# Usar um dicionário é bom porque podemos adicionar outras coisas depois (ex: moedas, nome do jogador).
var dados_do_jogo: Dictionary


# Esta função é chamada automaticamente quando o jogo inicia
func _ready():
	carregar_jogo()


func carregar_jogo():
	
	if not FileAccess.file_exists(CAMINHO_SAVE):
		dados_do_jogo = {
			"fase_atual": 1,
			"moedas": 0,
		}
		return

	var arquivo = FileAccess.open(CAMINHO_SAVE, FileAccess.READ)
	var conteudo_json = arquivo.get_as_text()
	dados_do_jogo = JSON.parse_string(conteudo_json)


func salvar_jogo():
	var arquivo = FileAccess.open(CAMINHO_SAVE, FileAccess.WRITE)
	var json_como_texto = JSON.stringify(dados_do_jogo, "\t")
	arquivo.store_string(json_como_texto)
