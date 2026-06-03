class_name Main
extends SceneTree

var definition: GameDefinition
var state: GameState

func _init() -> void:
	print("=========================================")
	print(" INICIALIZANDO KERNEL SIMULATION HEADLESS")
	print("=========================================\n")
	
	# 1. Configurando os dados iniciais (Setup do Estado baseado na Definição)
	definition = GameDefinition.new()
	state = GameState.new()
	
	print("Jogo configurado: Tabuleiro %dx%d" % [definition.board_size, definition.board_size])
	_print_board_to_console()
	
	# 2. Simulando o Loop de Ações (Ações -> Validação -> Efeito)
	print("\n--- [Ação 1] Jogador X tenta jogar no centro (1,1) ---")
	_execute_action(Vector2i(1, 1), GameDefinition.PIECE_X)
	
	print("\n--- [Ação 2] Jogador O tenta jogar no mesmo lugar (1,1) (DEVE FALHAR) ---")
	_execute_action(Vector2i(1, 1), GameDefinition.PIECE_O)
	
	print("\n--- [Ação 3] Jogador O joga no canto superior esquerdo (0,0) ---")
	_execute_action(Vector2i(0, 0), GameDefinition.PIECE_O)
	
	print("\n--- [Ação 4] Jogador X joga fora do tabuleiro (5,5) (DEVE FALHAR) ---")
	_execute_action(Vector2i(5, 5), GameDefinition.PIECE_X)
	
	print("\n--- [Ação 5] Sequência para X vencer na coluna central ---")
	_execute_action(Vector2i(1, 0), GameDefinition.PIECE_X) # O joga em algum lugar
	_execute_action(Vector2i(0, 1), GameDefinition.PIECE_O) 
	_execute_action(Vector2i(1, 2), GameDefinition.PIECE_X) # X ganha!
	
	print("\n=========================================")
	print(" SIMULAÇÃO FINALIZADA COM SUCESSO")
	print("=========================================")
	quit() # Desliga o processo headless

# Orquestra o pipeline da ação
func _execute_action(coord: Vector2i, piece: int) -> void:
	if GameRules.validate_move(state, definition, coord, piece):
		GameRules.apply_move(state, definition, coord, piece)
	_print_board_to_console()

# Uma função "boba" de debug visual em modo texto
func _print_board_to_console() -> void:
	print("Turno Atual: %s" % definition.get_piece_name(state.current_turn))
	print("Status do Tabuleiro:")
	for y in range(definition.board_size):
		var row_string = "	"
		for x in range(definition.board_size):
			var current_piece = state.board.get(Vector2i(x, y), GameDefinition.PIECE_NONE)
			row_string += definition.get_piece_name(current_piece) + " "
		print(row_string)

# ----

# extends SceneTree

# func _init():
# 	print("\n--- Godot CLI App Started ---")

# 	# Retrieve arguments passed after the script path
# 	#var args = OS.get_cmdline_args()	# gets ALL args
# 	var args = OS.get_cmdline_user_args()	# gets only args after ' -- '
# 	print("User arguments passed: ", args)

# 	# Wrap up your execution and close the program
# 	quit()
