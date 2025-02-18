extends Node

var destinations: Dictionary

func _init() -> void:
	destinations = load_destinations_db()


func load_destinations_db():
	var file = "res://utils/destinations.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict
