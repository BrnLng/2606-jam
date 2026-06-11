class_name Main
extends SceneTree

var state: GameState

func _init() -> void:
	# 1. Configurando o Estado Agnóstico (Baseado em Zonas e Entidades)
	state = GameState.new()
	
	# Registrando a Zona principal (o Tabuleiro)
	var board_zone = Zone.new("board", "grid")
	board_zone.max_capacity = 9
	state.register_zone(board_zone)
	
	print("Jogo configurado: Zona 'board' (ECS based).")
	_print_board_to_console()
	
	# 2. Simulando Ações via Criação de Entidades (Composition Pattern)
	print("\n--- [Ação 1] Criando Entidade (X) no centro (1,1) ---")
	_spawn_piece_entity(Vector2i(1, 1), "piece_x")
	
	print("\n--- [Ação 2] Criando Entidade (O) no canto (0,0) ---")
	_spawn_piece_entity(Vector2i(0, 0), "piece_o")
	
	print("\n--- [Ação 3] Criando Entidade (X) na direita (2,1) ---")
	_spawn_piece_entity(Vector2i(2, 1), "piece_x")
	
	quit()

# Cria uma entidade puramente via componentes (Padrão ECS)
func _spawn_piece_entity(coord: Vector2i, type_id: String) -> void:
	var entity = state.create_entity()
	entity.add_component(GridPositionComponent.new(coord))
	entity.add_component(TypeComponent.new(type_id))
	
	# Adiciona à Zona do tabuleiro
	var board = state.zones.get("board")
	if board and board.has_space():
		board.entity_ids.append(entity.id)
		
	_print_board_to_console()

# Lendo o estado agnóstico pesquisando por Entidades e Componentes
func _print_board_to_console() -> void:
	var board_size = 3
	print("Turno Atual do Jogador: %d" % state.current_turn_owner)
	print("Status da Zona 'board':")
	for y in range(board_size):
		var row_string = "	"
		for x in range(board_size):
			var piece_visual = "."
			# Query the zone for any entity matching this grid coordinate
			if state.zones.has("board"):
				for entity_id in state.zones["board"].entity_ids:
					var entity = state.entities[entity_id]
					var pos_comp = entity.get_component(GridPositionComponent) as GridPositionComponent
					
					if pos_comp and pos_comp.coord == Vector2i(x, y):
						var type_comp = entity.get_component(TypeComponent) as TypeComponent
						if type_comp.type_id == "piece_x": piece_visual = "X"
						elif type_comp.type_id == "piece_o": piece_visual = "O"
						break # Stop searching, we found a piece for this tile
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
