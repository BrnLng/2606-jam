class_name GameDefinition
extends Resource

@export var board_size: int = 3
@export var win_condition_length: int = 3

# Definições estáticas dos tipos de peças/jogadores
const PIECE_NONE = 0
const PIECE_X = 1
const PIECE_O = 2

func get_piece_name(piece_type: int) -> String:
	match piece_type:
		PIECE_X: return "X"
		PIECE_O: return "O"
		_: return "."
