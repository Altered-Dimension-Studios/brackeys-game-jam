extends Node2D

@onready var plane_start: Node2D = $Map/Markers/MapStart
@onready var plane_end: Node2D = $Map/Markers/MapEnd
@onready var interceptor_start: Node2D = $Map/Markers/MapInterceptorStart
@onready var interceptor_end: Node2D = $Map/Markers/MapInterceptorEnd

var airplane: Airplane
var interceptor: Interceptor

var selected_plane: Airplane
	
func _ready() -> void:
	airplane = preload("res://Scenes/Airplane.tscn").instantiate() as Airplane
	interceptor = preload("res://Scenes/Interceptor.tscn").instantiate() as Interceptor
	
	airplane.constructor([plane_start, plane_end])
	interceptor.constructor([plane_start, plane_end], 90000)
	
	airplane.plane_clicked.connect(_plane_selected.bind(airplane))
	interceptor.plane_clicked.connect(_plane_selected.bind(interceptor))
	
	add_child(airplane)
	add_child(interceptor)

	airplane.move_to_marker(plane_start)
	interceptor.move_to_marker(interceptor_start)

func _process(delta: float) -> void:


	airplane.update_screen_position()
	interceptor.update_screen_position()
	
	if airplane.position.x < plane_end.position.x:
		remove_child(airplane)		
	if interceptor.position.x < interceptor_end.position.x:
		remove_child(interceptor)	
	
	if selected_plane:
		$Layout/FlightDetailsPanel/SpeedValue.text = str(selected_plane.air_speed)
	

func _plane_selected(plane: Airplane) -> void:
	selected_plane = plane

func _on_button_intercept_pressed() -> void:
	pass 
	
