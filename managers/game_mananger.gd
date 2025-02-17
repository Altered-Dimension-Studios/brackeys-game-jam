extends Node2D

# Preload scenes
var game_scene: PackedScene = preload("res://scenes/game_scene.tscn")
var main_menu_scene: PackedScene = null
var pause_menu_scene: PackedScene = null

# Global instances
var instantiated_game_scene: Node2D = null
var instantiated_main_menu_scene: Node2D = null
var instantiated_pause_menu_scene: Node2D = null

func _init():
	#initialize_menu()
	initialize_game()
	
func initialize_menu():
	instantiated_main_menu_scene = main_menu_scene.instantiate()
	add_child(instantiated_main_menu_scene)
	
func initialize_game():
	instantiated_game_scene = game_scene.instantiate()
	add_child(instantiated_game_scene)

func pause_game():
	if(get_tree().paused):
		get_tree().paused = true
		instantiated_pause_menu_scene = pause_menu_scene.instantiate()
	else :
		get_tree().paused = false
		instantiated_pause_menu_scene.free()
