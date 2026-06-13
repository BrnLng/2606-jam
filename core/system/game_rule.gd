class_name GameRules
extends RefCounted

static func _get_type_id_for_piece(piece: int) -> String:
	return "piece_x" if piece == GameDefinition.PIECE_X else "piece_o"

static func _get_piece_from_type_id(type_id: String) -> int:
	if type_id == "piece_x": return GameDefinition.PIECE_X
	if type_id == "piece_o": return GameDefinition.PIECE_O
	return GameDefinition.PIECE_NONE

# Valida se uma ação de jogar peça é permitida
static func validate_move(state: GameState, definition: GameDefinition, coord: Vector2i, piece: int) -> bool:
	if state.game_over:
		print("[Validation Failed] O jogo já terminou.")
		return false

	if piece != state.current_turn_owner:
		print("[Validation Failed] Não é o turno desta peça.")
		return false

	if coord.x < 0 or coord.x >= definition.board_size or coord.y < 0 or coord.y >= definition.board_size:
		print("[Validation Failed] Coordenada fora do tabuleiro.")
		return false

	var existing_type = state.get_piece_at(coord)
	if existing_type != "":
		print("[Validation Failed] Esta célula já está ocupada.")
		return false

	return true

# Aplica a ação diretamente no estado (Mutação controlada)
static func apply_move(state: GameState, definition: GameDefinition, coord: Vector2i, piece: int) -> void:
	# Spawns entity into the ECS
	var entity = state.create_entity()
	entity.add_component(GridPositionComponent.new(coord))
	entity.add_component(TypeComponent.new(_get_type_id_for_piece(piece)))
	
	var board = state.zones.get("board")
	if board:
		board.entity_ids.append(entity.id)
		
	print("[Kernel Effect] Peça %s colocada em %s" % [definition.get_piece_name(piece), coord])

	# Verifica vitória ou empate antes de passar o turno
	if _check_victory(state, definition, coord, piece):
		state.game_over = true
		state.winner_id = piece
		print("[Kernel Event] Jogo Terminou! Vitória do jogador %s" % definition.get_piece_name(piece))
		return

	if board and board.entity_ids.size() >= (definition.board_size * definition.board_size):
		state.game_over = true
		state.winner_id = GameDefinition.PIECE_NONE
		print("[Kernel Event] Jogo Terminou! Empate (Velha).")
		return

	# Passa o turno
	state.current_turn_owner = GameDefinition.PIECE_O if piece == GameDefinition.PIECE_X else GameDefinition.PIECE_X

# Algoritmo simples de checagem de vitória no Tic-Tac-Toe
static func _check_victory(state: GameState, definition: GameDefinition, last_coord: Vector2i, piece: int) -> bool:
	var size = definition.board_size
	var piece_type = _get_type_id_for_piece(piece)

	# Checa Linha
	var row_win = true
	for x in range(size):
		if state.get_piece_at(Vector2i(x, last_coord.y)) != piece_type:
			row_win = false
			break
	if row_win: return true

	# Checa Coluna
	var col_win = true
	for y in range(size):
		if state.get_piece_at(Vector2i(last_coord.x, y)) != piece_type:
			col_win = false
			break
	if col_win: return true

	# Checa Diagonais (se aplicável à coordenada)
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
