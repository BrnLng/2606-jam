class_name Main
extends SceneTree

var state: GameState
var definition: GameDefinition

func _init() -> void:
	print("\n--- Godot CLI App Started ---")

	# 1. Configurando o Estado Agnóstico (Baseado em Zonas e Entidades)
	state = GameState.new()
	definition = GameDefinition.new()
	
	# Registrando a Zona principal (o Tabuleiro)
	var board_zone = Zone.new("board", "grid")
	board_zone.max_capacity = 9
	state.register_zone(board_zone)
	
	print("Jogo configurado: Zona 'board' (ECS based).")
	
	_print_board_to_console()
	
	# Loop Interativo
	_game_loop()
	
	quit()

func _game_loop() -> void:
	while not state.game_over:
		print("\nTurno do Jogador %s" % definition.get_piece_name(state.current_turn_owner))
		print("Digite a coordenada (ex: 0,1 ou 2,2) ou 'q' para sair:")
		
		# Godot 4.x has this blocking call for CLI input
		var input_str = OS.read_string_from_stdin().strip_edges()
		
		if input_str.to_lower() == "q" or input_str.to_lower() == "quit":
			print("Saindo do jogo...")
			break
			
		var parts = input_str.split(",")
		if parts.size() != 2:
			print("Formato inválido. Use X,Y (ex: 1,1)")
			continue
			
		var x = parts[0].to_int()
		var y = parts[1].to_int()
		var coord = Vector2i(x, y)
		
		if GameRules.validate_move(state, definition, coord, state.current_turn_owner):
			GameRules.apply_move(state, definition, coord, state.current_turn_owner)
			_print_board_to_console()
		else:
			print("Tente novamente.")
			
	if state.game_over:
		if state.winner_id != GameDefinition.PIECE_NONE:
			print("\n*** JOGADOR %s VENCEU! ***\n" % definition.get_piece_name(state.winner_id))
		else:
			print("\n*** EMPATE! ***\n")

# Lendo o estado agnóstico pesquisando por Entidades e Componentes
func _print_board_to_console() -> void:
	var board_size = definition.board_size
	print("\nStatus da Zona 'board':")
	for y in range(board_size):
		var row_string = "	"
		for x in range(board_size):
			var piece_visual = "."
			var type_id = state.get_piece_at(Vector2i(x, y))
			if type_id == "piece_x": piece_visual = "X"
			elif type_id == "piece_o": piece_visual = "O"
			row_string += piece_visual + " "
		print(row_string)

# ---- Below is the original code from when the project was a simple CLI app -- to be kept as reference to later add cmdline_args parsing

# extends SceneTree

# func _init():
# 	print("\n--- Godot CLI App Started ---")

# 	# Retrieve arguments passed after the script path
# 	#var args = OS.get_cmdline_args()	# gets ALL args
# 	var args = OS.get_cmdline_user_args()	# gets only args after ' -- '
# 	print("User arguments passed: ", args)

# 	# Wrap up your execution and close the program
# 	quit()
