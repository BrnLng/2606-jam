class_name GameState
extends RefCounted

var entities: Dictionary = {} # int (ID) -> Entity
var zones: Dictionary = {} # String (ID) -> Zone
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


func get_piece_at(coord: Vector2i) -> String:
	var board = zones.get("board")
	if not board:
		return ""
	for entity_id in board.entity_ids:
		var entity = entities.get(entity_id)
		if not entity: continue
		var pos_comp = entity.get_component(GridPositionComponent) as GridPositionComponent
		if pos_comp and pos_comp.coord == coord:
			var type_comp = entity.get_component(TypeComponent) as TypeComponent
			if type_comp:
				return type_comp.type_id
	return ""


func clone() -> GameState:
	var copy = GameState.new()
	# TODO: Deep copy entities and zones
	copy.current_turn_owner = self.current_turn_owner
	copy.game_over = self.game_over
	copy.winner_id = self.winner_id
	return copy
