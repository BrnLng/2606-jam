class_name Entity
extends RefCounted

var id: int
var _components: Dictionary = {}  # Chave: Nome da Classe -> Valor: Instância


func _init(_id: int):
	id = _id


func add_component(component: Component) -> void:
	var script_name = component.get_script().get_path().get_file().get_basename()
	_components[script_name] = component


func get_component(component_class: Script) -> Component:
	var script_name = component_class.get_path().get_file().get_basename()
	return _components.get(script_name, null)


func has_component(component_class: Script) -> bool:
	var script_name = component_class.get_path().get_file().get_basename()
	return _components.has(script_name)
