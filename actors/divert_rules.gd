extends Control

@onready var destinations_page_node = $DestinationsPage
@onready var destinations_list_node = $DestinationsPage/ItemList
@onready var cover_page_node = $Cover

func _ready() -> void:
	for name in DestinationsDatabase.destinations:
		add_destination_button(name)


func add_destination_button(destination_name: String) -> void:
	var button = Button.new()
	button.text = destination_name
	destinations_list_node.add_child(button)


func _on_cover_button_up() -> void:
	cover_page_node.visible = false
	destinations_page_node.visible = true
