class_name Zone
extends RefCounted

var zone_id: String
var entity_ids: Array[int] = []
var layout_type: String # "grid", "linear", "stack"

# Zone limits (Component.Limits)
var max_capacity: int = -1

func _init(_zone_id: String, _layout_type: String = &"linear"):
	zone_id = _zone_id
	layout_type = _layout_type

func has_space() -> bool:
	if max_capacity == -1: return true
	return entity_ids.size() < max_capacity
