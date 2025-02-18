extends Node
class_name DivertRule

var destination_name: String
# Basically plane name
var allowed_airframe: String
var min_weight: int
var max_weight: int
const WEIGHT_OFFSET: int = 10_000
const MIN_WEIGHT: int = 20_000
const MAX_WEIGHT: int = 35_000

func generate_rules() -> void:
	generate_weight_range(MIN_WEIGHT, MAX_WEIGHT)
	generate_allowed_airframe()

func generate_weight_range(min_value: int, max_value: int) -> void:
	min_weight = randi_range(min_value, max_value)
	max_weight = min_weight + WEIGHT_OFFSET
	

func generate_allowed_airframe() -> void:
	var planes = PlanesDatabase.plane_names
	allowed_airframe = planes[randi() % planes.size()]
