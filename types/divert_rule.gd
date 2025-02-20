extends Node
class_name DivertRule

var destination_name: String
var rules: Dictionary
# Basically plane name
const WEIGHT_OFFSET: int = 10_000
const MIN_WEIGHT: int = 20_000
const MAX_WEIGHT: int = 35_000

func generate_rules() -> void:
	generate_weight_range(MIN_WEIGHT, MAX_WEIGHT)
	generate_allowed_airframe()

func generate_weight_range(min_value: int, max_value: int) -> void:
	rules["min_weight"] = randi_range(min_value, max_value)
	rules["max_weight"] = rules["min_weight"] + WEIGHT_OFFSET
	

func generate_allowed_airframe() -> void:
	var planes = PlanesDatabase.plane_names
	rules["allowed_airframe"] = planes[randi() % planes.size()]
