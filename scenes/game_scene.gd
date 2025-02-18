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
	AirplaneManagerInstance.can_intercept = true
	$ButtonIntercept.disabled = false
