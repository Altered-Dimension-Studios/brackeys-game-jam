extends Node
class_name DivertRuleManager

var divert_rules: Dictionary


func _init() -> void:
	initialize_divert_rules()


func initialize_divert_rules() -> void:
	for name in DestinationsDatabase.destinations:
		var rule: DivertRule = DivertRule.new()
		rule.destination_name = name
		rule.generate_rules()
		divert_rules[name] = rule
