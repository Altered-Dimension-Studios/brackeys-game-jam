extends Node2D
	
@onready var plane_start: Node2D = $Map/Markers/MapStart
@onready var plane_end: Node2D = $Map/Markers/MapEnd
@onready var interceptor_start: Node2D = $Map/Markers/MapInterceptorStart
@onready var interceptor_end: Node2D = $Map/Markers/MapInterceptorEnd
	
var AirplaneManagerAsset = preload("res://managers/airplane_manager.tscn")
var AirplaneManagerInstance: AirplaneManager

func _init() -> void:
	AirplaneManagerInstance = AirplaneManagerAsset.instantiate() as AirplaneManager
	AirplaneManagerInstance.ready_instance.connect(_airplane_manager_ready.bind())
	SignalBus.plane_clicked.connect(_plane_selected.bind())
	SignalBus.plane_entered_interception.connect(_plane_entered_interception.bind())
	SignalBus.plane_intercepted.connect(_plane_intercepted.bind())

func _ready() -> void:
	AirplaneManagerInstance.constructor(
		plane_start, 
		plane_end,
		interceptor_start,
		interceptor_end
		)
	add_child(AirplaneManagerInstance)
	
func _airplane_manager_ready() -> void:
	AirplaneManagerInstance._test_spawn()

func _on_button_intercept_pressed() -> void:
	if AirplaneManagerInstance._intercept():
		$ButtonIntercept.disabled = true
		$ButtonIntercept/CooldownTimer.start()


func _process(delta: float) -> void:
	if AirplaneManagerInstance && AirplaneManagerInstance.selected_plane:
		$Layout/FlightDetailsPanel/SpeedValue.text = str(
			AirplaneManagerInstance.selected_plane.air_speed)
	else:
		$Layout/FlightDetailsPanel/SpeedValue.text = "- - - - -"
		
func _on_cooldown_timer_timeout() -> void:
	if AirplaneManagerInstance.selected_plane != null && \
	AirplaneManagerInstance.selected_plane is not Interceptor: 
		AirplaneManagerInstance.can_intercept = true
		$ButtonIntercept.disabled = false


func _on_button_fire_pressed() -> void:
	if AirplaneManagerInstance._destroy_intercepted_plane():
		$ButtonFire.disabled = true

func _plane_selected(plane: Airplane) -> void:
	if plane is not Interceptor && \
	$ButtonIntercept/CooldownTimer.time_left == 0 && \
	plane.in_interception_area:
		$ButtonIntercept.disabled = false

func _plane_intercepted(plane: Airplane) -> void:
	$ButtonFire.disabled = false

func _plane_entered_interception(plane: Airplane) -> void:
	if plane is not Interceptor && \
	$ButtonIntercept/CooldownTimer.time_left == 0 && \
	AirplaneManagerInstance.selected_plane == plane:
		$ButtonIntercept.disabled = false
		
