extends Node2D

@onready var plane_start: Node2D = $Map/Markers/MapStart
@onready var plane_end: Node2D = $Map/Markers/MapEnd
@onready var interceptor_start: Node2D = $Map/Markers/MapInterceptorStart
@onready var interceptor_end: Node2D = $Map/Markers/MapInterceptorEnd
var airplane_actor = preload("res://actors/airplane.tscn")
var interceptor_actor = preload("res://actors/interceptor.tscn")
var airplane: Airplane
var interceptor: Interceptor

var num_airplanes = 0
var num_interceptors = 0

var can_intercept = true

const MAX_DISTANCE = 20000 #km

var selected_plane: Airplane
	
func _ready() -> void:
	SignalBus.plane_removed.connect(_on_plane_removed.bind())
	
	_spawn_airplane()
	await get_tree().create_timer(4).timeout
	_spawn_airplane()


func _plane_selected(plane: Airplane) -> void:
	selected_plane = plane
	
func _on_plane_removed(plane: Airplane) -> void:
	if selected_plane == plane:
		selected_plane = null
	
	if plane is Interceptor:
		num_interceptors -= 1
	else:
		num_airplanes -= 1


func _spawn_airplane() -> void:
	var plane_data = PlanesDatabase.get_random_plane()
	airplane = airplane_actor.instantiate() as Airplane
	airplane.constructor([plane_start, plane_end], MAX_DISTANCE)	
	airplane.plane_clicked.connect(_plane_selected.bind(airplane))
	add_child(airplane)
	airplane.move_to_marker(plane_start)
	num_airplanes += 1

func _spawn_interceptor() -> void:
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

func _on_button_intercept_pressed() -> void:
	if can_intercept && selected_plane && \
	selected_plane is not Interceptor && \
	selected_plane.in_interception_area:
		if num_interceptors == 0:
			_spawn_interceptor()
			num_interceptors += 1
		interceptor.intercept_target = selected_plane
		can_intercept = false
		$ButtonIntercept.disabled = true
		$ButtonIntercept/CooldownTimer.start()


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
		


func _on_cooldown_timer_timeout() -> void:
	can_intercept = true
	$ButtonIntercept.disabled = false
