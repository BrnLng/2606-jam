class_name GameState
extends RefCounted

var entities: Dictionary = {} # int (ID) -> Entity
var zones: Dictionary = {}    # String (ID) -> Zone
var current_turn_owner: int = 1
var game_over: bool = false
var winner_id: int = 0

var _next_entity_id: int = 1

func create_entity() -> Entity:
	var id = _next_entity_id
	_next_entity_id += 1
	var entity = Entity.new(id)
	entities[id] = entity
	return entity


func register_zone(zone: Zone) -> void:
	zones[zone.zone_id] = zone


func clone() -> GameState:
	var copy = GameState.new()
	copy.board = self.board.duplicate()
	copy.current_turn = self.current_turn
	copy.game_over = self.game_over
	copy.winner = self.winner
	return copy
