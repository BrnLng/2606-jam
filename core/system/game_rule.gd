class_name GameRules
extends RefCounted

static func _get_type_id_for_piece(piece: int) -> String:
	return "piece_x" if piece == GameDefinition.PIECE_X else "piece_o"

static func _get_piece_from_type_id(type_id: String) -> int:
	if type_id == "piece_x": return GameDefinition.PIECE_X
	if type_id == "piece_o": return GameDefinition.PIECE_O
	return GameDefinition.PIECE_NONE

# Validates if a piece play action is allowed
static func validate_move(state: GameState, definition: GameDefinition, coord: Vector2i, piece: int) -> bool:
	if state.game_over:
		print("[Validation Failed] Game is ended already.")
		return false

	if piece != state.current_turn_owner:
		print("[Validation Failed] It is not this piece's turn.")
		return false

	if coord.x < 0 or coord.x >= definition.board_size or coord.y < 0 or coord.y >= definition.board_size:
		print("[Validation Failed] Coordinate out of board.")
		return false

	var existing_type = state.get_piece_at(coord)
	if existing_type != "":
		print("[Validation Failed] This cell is already occupied.")
		return false

	return true

# Returns a list of all currently valid moves for a given piece
static func get_valid_moves(state: GameState, definition: GameDefinition, piece: int) -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	
	if state.game_over or piece != state.current_turn_owner:
		return valid_moves
		
	for y in range(definition.board_size):
		for x in range(definition.board_size):
			var coord = Vector2i(x, y)
			# Avoid using validate_move directly to prevent console spam
			if state.get_piece_at(coord) == "":
				valid_moves.append(coord)
				
	return valid_moves

# Applies action directly to state (controlled mutation)
static func apply_move(state: GameState, definition: GameDefinition, coord: Vector2i, piece: int) -> void:
	# Spawns entity into the ECS
	var entity = state.create_entity()
	entity.add_component(GridPositionComponent.new(coord))
	entity.add_component(TypeComponent.new(_get_type_id_for_piece(piece)))
	
	var board = state.zones.get("board")
	if board:
		board.entity_ids.append(entity.id)
		
	print("[Kernel Effect] Piece %s placed at %s" % [definition.get_piece_name(piece), coord])

	# Checks victory or draw before passing the turn
	if _check_victory(state, definition, coord, piece):
		state.game_over = true
		state.winner_id = piece
		print("[Kernel Event] Game ended! Victory of player %s" % definition.get_piece_name(piece))
		return

	if board and board.entity_ids.size() >= (definition.board_size * definition.board_size):
		state.game_over = true
		state.winner_id = GameDefinition.PIECE_NONE
		print("[Kernel Event] Game ended! Draw (Tic-Tac-Toe).")
		return

	# Pass the turn
	state.current_turn_owner = GameDefinition.PIECE_O if piece == GameDefinition.PIECE_X else GameDefinition.PIECE_X

# Simple algorithm to check for victory in Tic-Tac-Toe
static func _check_victory(state: GameState, definition: GameDefinition, last_coord: Vector2i, piece: int) -> bool:
	var size = definition.board_size
	var piece_type = _get_type_id_for_piece(piece)

	# Checks Line
	var row_win = true
	for x in range(size):
		if state.get_piece_at(Vector2i(x, last_coord.y)) != piece_type:
			row_win = false
			break
	if row_win: return true

	# Checks Column
	var col_win = true
	for y in range(size):
		if state.get_piece_at(Vector2i(last_coord.x, y)) != piece_type:
			col_win = false
			break
	if col_win: return true

	# Checks Diagonals (if applicable to the coordinate)
	if last_coord.x == last_coord.y:
		var diag1_win = true
		for i in range(size):
			if state.get_piece_at(Vector2i(i, i)) != piece_type:
				diag1_win = false
				break
		if diag1_win: return true

	if last_coord.x + last_coord.y == size - 1:
		var diag2_win = true
		for i in range(size):
			if state.get_piece_at(Vector2i(i, size - 1 - i)) != piece_type:
				diag2_win = false
				break
		if diag2_win: return true

	return false
