extends Control
class_name DivertRules


@onready var destinations_page_node = $DestinationsPage
@onready var destinations_list_node = $DestinationsPage/ItemList
@onready var cover_page_node = $Cover

var pages: Array = []
var page_scene = preload("res://actors/page.tscn")
var left_page: Page 
var right_page: Page

func _init() -> void:
	initialize_pages()


func _ready() -> void:
	$Pages/HBoxContainer.add_child(left_page)
	$Pages/HBoxContainer.add_child(right_page)
	for name in DestinationsDatabase.destinations:
		add_destination_button(name)
	


func add_destination_button(destination_name: String) -> void:
	var button = Button.new()
	button.text = destination_name
	destinations_list_node.add_child(button)


func _on_cover_button_up() -> void:
	cover_page_node.visible = false
	destinations_page_node.visible = true


func initialize_pages() -> void:
	left_page = page_scene.instantiate()
	right_page = page_scene.instantiate()
