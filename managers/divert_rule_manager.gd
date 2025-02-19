extends Node
class_name DivertRuleManager

var divert_rules: Dictionary
var divert_rules_ui_scene = preload("res://actors/divert_rules.tscn")
var divert_rules_ui_instance: DivertRules


func _ready() -> void:
	divert_rules_ui_instance = divert_rules_ui_scene.instantiate()
	initialize_divert_rules()
	add_child(divert_rules_ui_instance)


func initialize_divert_rules() -> void:
	for name in DestinationsDatabase.destinations:
		var rule: DivertRule = DivertRule.new()
		rule.destination_name = name
		rule.generate_rules()
		divert_rules[name] = rule
		divert_rules_ui_instance.left_page.fill_page(rule)
