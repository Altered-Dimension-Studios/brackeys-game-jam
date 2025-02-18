extends Node

class_name AirplaneManager

var plane_start: Node2D
var plane_end: Node2D
var interceptor_start: Node2D
var interceptor_end: Node2D
var airplane_actor = preload("res://actors/airplane.tscn")
var interceptor_actor = preload("res://actors/interceptor.tscn")
var airplane: Airplane
var interceptor: Interceptor

var num_airplanes = 0
var num_interceptors = 0

var can_intercept = true

const MAX_DISTANCE = 20000 #km

var selected_plane: Airplane

signal ready_instance

func constructor(_plane_start, _plane_end, _interceptor_start, _interceptor_end) -> void:
	plane_start = _plane_start
	plane_end = _plane_end
	interceptor_start = _interceptor_start
	interceptor_end = _interceptor_end

func _init() -> void:
	SignalBus.plane_removed.connect(_on_plane_removed.bind())
	SignalBus.plane_clicked.connect(_plane_selected.bind())
	
func _ready() -> void:
	emit_signal("ready_instance")

func _test_spawn():
	_spawn_airplane()
	await get_tree().create_timer(4).timeout
	_spawn_airplane()
	await get_tree().create_timer(20).timeout
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
	# Instantiate Airplane and attach details from DB on it
	# We'll need to mix and match some values from DB to give false information about planes
	# Control whole airplane flow from manager. This means:
		# Spawn airplane on timer
		# Handle all possible cases. We should add an enum: INTERCEPT, DIVERT, FIRE, ALLOW
		# Play animations and sounds on airplane
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

func _intercept() -> bool:
	if can_intercept && selected_plane && \
	selected_plane is not Interceptor && \
	selected_plane.in_interception_area:
		if num_interceptors == 0:
			_spawn_interceptor()
			num_interceptors += 1
		interceptor.intercept_target = selected_plane
		can_intercept = false
		return true
	return false

func _destroy_intercepted_plane() -> bool:
	if selected_plane && \
		interceptor.intercept_target == selected_plane && \
		abs(interceptor.intercept_target.distance - interceptor.distance) < 10:
			SignalBus.plane_removed.emit(interceptor.intercept_target)
			interceptor.intercept_target.free()
			print("Destroyed plane")
			return true
	return false
