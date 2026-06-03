class_name TypeComponent
extends Component

var type_id: String  # ex: "piece_x", "piece_o", "card_hero"

func _init(_type_id: String):
	type_id = _type_id
