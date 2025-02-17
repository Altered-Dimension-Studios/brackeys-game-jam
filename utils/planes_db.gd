extends Node

var planes_array: Dictionary = load_planes_db()

func load_planes_db():
	var file = "res://utils/planes_db.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict
	
func get_random_plane():
	var plane_dict_size = self.planes_array.size()
	var random_plane_key = self.planes_array.keys()[randi() % plane_dict_size]
	var random_plane = self.planes_array[random_plane_key]
	return random_plane
