extends TextureRect
class_name Page


func fill_page(rule: DivertRule) -> void:
	$DestinationLabel.text = rule.destination_name
	for key in rule.rules:
		print(key)
