extends Node2D

@onready var plane_start: Node2D = $Map/Markers/MapStart
@onready var plane_end: Node2D = $Map/Markers/MapEnd
@onready var interceptor_start: Node2D = $Map/Markers/MapInterceptorStart
@onready var interceptor_end: Node2D = $Map/Markers/MapInterceptorEnd
var airplane_actor = preload("res://actors/airplane.tscn")
var interceptor_actor = preload("res://actors/interceptor.tscn")
var airplane: Airplane
var interceptor: Interceptor

const MAX_DISTANCE = 20000 #km

var selected_plane: Airplane
	
func _ready() -> void:
	SignalBus.plane_removed.connect(_on_plane_removed.bind())
	
	var plane_data = PlanesDatabase.get_random_plane()
	airplane = airplane_actor.instantiate() as Airplane
	airplane.constructor([plane_start, plane_end], MAX_DISTANCE)	
	airplane.plane_clicked.connect(_plane_selected.bind(airplane))
	add_child(airplane)

	airplane.move_to_marker(plane_start)


func _plane_selected(plane: Airplane) -> void:
	selected_plane = plane

func _on_plane_removed(plane: Airplane) -> void:
	if selected_plane == plane:
		selected_plane = null

func _on_button_intercept_pressed() -> void:
	if selected_plane && \
	selected_plane != Interceptor && \
	selected_plane.in_interception_area:
		var interceptor_start_distance = remap(interceptor_start.position.x, plane_end.position.x, plane_start.position.x, 0, MAX_DISTANCE)

		interceptor = interceptor_actor.instantiate() as Interceptor
		interceptor.constructor(
			[plane_start, plane_end], 
			MAX_DISTANCE, 
			interceptor_start_distance
			)
		interceptor.plane_clicked.connect(_plane_selected.bind(interceptor))
		add_child(interceptor)
		interceptor.move_to_marker(interceptor_start)


func _process(delta: float) -> void:
	#if airplane != null && airplane.position.x <= plane_end.position.x:
		#remove_child(airplane)
		#selected_plane = null
		#airplane.free()
	#if interceptor != null && interceptor.position.x < interceptor_end.position.x:
			#$ButtonIntercept/CooldownTimer.start()
			#interceptor.visible = false
			#selected_plane = null
	#
	if selected_plane:
		$Layout/FlightDetailsPanel/SpeedValue.text = str(selected_plane.air_speed)
	else:
		$Layout/FlightDetailsPanel/SpeedValue.text = "- - - - -"
		
