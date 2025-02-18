extends Node
class_name DestinationRule

var destination_name: String
var min_weight: int
var max_weight: int
const WEIGHT_OFFSET = 10_000
const MIN_WEIGHT = 20_000
const MAX_WEIGHT = 35_000

func generate_rules() -> void:
	generate_weight_range(MIN_WEIGHT, MAX_WEIGHT)


func generate_weight_range(min_value: int, max_value: int) -> void:
	min_weight = randi_range(min_value, max_value)
	max_weight = min_weight + WEIGHT_OFFSET
	
