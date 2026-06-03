class_name GameState
extends RefCounted

# O estado do tabuleiro representado de forma linear ou coordenada
# Chave: Vector2i(x, y) -> Valor: int (PIECE_X, PIECE_O, PIECE_NONE)
var board: Dictionary = {}
var current_turn: int = GameDefinition.PIECE_X
var game_over: bool = false
var winner: int = GameDefinition.PIECE_NONE

func clone() -> GameState:
	var copy = GameState.new()
	copy.board = self.board.duplicate()
	copy.current_turn = self.current_turn
	copy.game_over = self.game_over
	copy.winner = self.winner
	return copy
