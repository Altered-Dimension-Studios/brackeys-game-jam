extends Node2D

@onready var plane_start: Node2D = $Map/Markers/MapStart
@onready var plane_end: Node2D = $Map/Markers/MapEnd
@onready var interceptor_start: Node2D = $Map/Markers/MapInterceptorStart
@onready var interceptor_end: Node2D = $Map/Markers/MapInterceptorEnd
var airplane_actor = preload("res://actors/airplane.tscn")
var interceptor_actor = preload("res://actors/interceptor.tscn")
var airplane: Airplane
var interceptor: Interceptor

var selected_plane: Airplane
var EVIL_DISTANCE_HARD_CODED = 84000
	
func _ready() -> void:
	airplane = airplane_actor.instantiate() as Airplane
	airplane.constructor([plane_start, plane_end])	
	airplane.plane_clicked.connect(_plane_selected.bind(airplane))
	add_child(airplane)

	airplane.move_to_marker(plane_start)


func _plane_selected(plane: Airplane) -> void:
	selected_plane = plane
	PlanesDatabase.get_random_plane()


func _on_button_intercept_pressed() -> void:
	interceptor = interceptor_actor.instantiate() as Interceptor
	interceptor.constructor([plane_start, plane_end], EVIL_DISTANCE_HARD_CODED)
	interceptor.plane_clicked.connect(_plane_selected.bind(interceptor))
	add_child(interceptor)
	interceptor.move_to_marker(interceptor_start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if airplane != null && airplane.position.x <= plane_end.position.x:
		#remove_child(airplane)
		#selected_plane = null
		#airplane.free()
	#if interceptor != null && interceptor.position.x < interceptor_end.position.x:
			#$ButtonIntercept/CooldownTimer.start()
			#interceptor.visible = false
			#selected_plane = null
	#
	#if selected_plane:
		#$Layout/FlightDetailsPanel/SpeedValue.text = str(selected_plane.air_speed)
