# eo:warner
# res://unit_test/test_game_rule.gd
extends GdUnitTestSuite

var definition: GameDefinition
var state: GameState

# Executa antes de CADA caso de teste para garantir um estado limpo
func before_test() -> void:
	definition = GameDefinition.new()
	state = GameState.new()

# Teste 1: Garantir que uma jogada válida em célula vazia é aceita
func test_validate_move_success() -> void:
	var is_valid = GameRules.validate_move(state, definition, Vector2i(1, 1), GameDefinition.PIECE_X)
	assert_bool(is_valid).is_true()

# Teste 2: Garantir que não pode jogar em célula já ocupada
func test_validate_move_occupied_cell_fails() -> void:
	# Forçamos um estado onde a célula (1,1) já está ocupada
	state.board[Vector2i(1, 1)] = GameDefinition.PIECE_X
	
	var is_valid = GameRules.validate_move(state, definition, Vector2i(1, 1), GameDefinition.PIECE_O)
	assert_bool(is_valid).is_false()

# Teste 3: Garantir que jogar fora do turno correto falha
func test_validate_move_wrong_turn_fails() -> void:
	# O turno inicial é do X, vamos tentar forçar o O a jogar
	var is_valid = GameRules.validate_move(state, definition, Vector2i(0, 0), GameDefinition.PIECE_O)
	assert_bool(is_valid).is_false()

# Teste 4: Validar se o algoritmo de vitória por linha funciona
func test_victory_condition_row() -> void:
	# Simulando vitória do X na linha superior (y=0)
	GameRules.apply_move(state, definition, Vector2i(0, 0), GameDefinition.PIECE_X) # Turno vira O
	GameRules.apply_move(state, definition, Vector2i(0, 1), GameDefinition.PIECE_O) # Turno vira X
	GameRules.apply_move(state, definition, Vector2i(1, 0), GameDefinition.PIECE_X) # Turno vira O
	GameRules.apply_move(state, definition, Vector2i(0, 2), GameDefinition.PIECE_O) # Turno vira X
	GameRules.apply_move(state, definition, Vector2i(2, 0), GameDefinition.PIECE_X) # Último movimento vitorioso
	
	assert_bool(state.game_over).is_true()
	assert_int(state.winner).is_equal(GameDefinition.PIECE_X)
