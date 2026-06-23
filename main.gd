class_name Main
extends SceneTree

var state: GameState
var definition: GameDefinition

var is_batch_mode: bool = false
var simulations_to_run: int = 1

func _init() -> void:
	print("\n--- Godot CLI App Started ---")

	var args = OS.get_cmdline_user_args()
	for arg in args:
		if arg == "--batch":
			is_batch_mode = true
		elif arg.begins_with("--simulate="):
			is_batch_mode = true
			simulations_to_run = arg.get_slice("=", 1).to_int()

	if is_batch_mode:
		for i in range(simulations_to_run):
			print("\n--- Starting Simulation %d ---" % (i + 1))
			_setup_game()
			_run_batch_simulation()
	else:
		_setup_game()
		_run_interactive_loop()
		
	quit()

func _setup_game() -> void:
	# 1. Agnostic State Configuration
	state = GameState.new()
	definition = GameDefinition.new()
	
	# 2. Register the main Zone (the Board)
	var board_zone = Zone.new("board", "grid")
	board_zone.max_capacity = definition.board_size * definition.board_size
	state.register_zone(board_zone)
	
	print("Game configured: Zone 'board' (ECS based).")
	_print_board_to_console()

func _run_batch_simulation() -> void:
	while not state.game_over:
		var valid_moves = GameRules.get_valid_moves(state, definition, state.current_turn_owner)
		if valid_moves.size() == 0:
			print("No valid moves available. Forcing game end.")
			break
			
		# Pick a random move
		var move = valid_moves[randi() % valid_moves.size()]
		print("\n%s Agent plays: %s" % [definition.get_piece_name(state.current_turn_owner), move])
		GameRules.apply_move(state, definition, move, state.current_turn_owner)
		_print_board_to_console()
		
	_print_result()

func _run_interactive_loop() -> void:
	while not state.game_over:
		print("\n%s Player Turn:" % definition.get_piece_name(state.current_turn_owner))
		print("Type coordinate (ex: 0,1 or 2,2) or 'q' to quit:")
		
		# Godot 4.x has this blocking call for CLI input
		var input_str = OS.read_string_from_stdin().strip_edges()
		
		if input_str.to_lower() == "q" or input_str.to_lower() == "quit":
			print("Quitting...")
			break
			
		var parts = input_str.split(",")
		if parts.size() != 2:
			print("Invalid format. Use X,Y (ex: 1,1)")
			continue
			
		var x = parts[0].to_int()
		var y = parts[1].to_int()
		var coord = Vector2i(x, y)
		
		if GameRules.validate_move(state, definition, coord, state.current_turn_owner):
			GameRules.apply_move(state, definition, coord, state.current_turn_owner)
			_print_board_to_console()
		else:
			print("Try again.")
			
	_print_result()

func _print_result() -> void:
	if state.game_over:
		if state.winner_id != GameDefinition.PIECE_NONE:
			print("\n*** Player %s WINS! ***\n" % definition.get_piece_name(state.winner_id))
		else:
			print("\n*** TIE! ***\n")

# Reading agnostic state by searching for Entities and Components
func _print_board_to_console() -> void:
	var board_size = definition.board_size
	print("\nState of 'board':")
	for y in range(board_size):
		var row_string = "	"
		for x in range(board_size):
			var piece_visual = "."
			var type_id = state.get_piece_at(Vector2i(x, y))
			if type_id == "piece_x": piece_visual = "X"
			elif type_id == "piece_o": piece_visual = "O"
			row_string += piece_visual + " "
		print(row_string)
