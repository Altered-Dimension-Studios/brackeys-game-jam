extends Node2D
	
@onready var plane_start: Node2D = $Map/Markers/MapStart
@onready var plane_end: Node2D = $Map/Markers/MapEnd
@onready var interceptor_start: Node2D = $Map/Markers/MapInterceptorStart
@onready var interceptor_end: Node2D = $Map/Markers/MapInterceptorEnd
	
var AirplaneManagerScene = preload("res://managers/airplane_manager.tscn")
var AirplaneManagerInstance: AirplaneManager

var DashboardManagerScene = preload("res://managers/dashboard_manager.tscn")
var DashboardManagerInstance: DashboardManager

func _init() -> void:
	AirplaneManagerInstance = AirplaneManagerScene.instantiate() as AirplaneManager
	AirplaneManagerInstance.ready_instance.connect(_airplane_manager_ready.bind())
	
	DashboardManagerInstance = DashboardManagerScene.instantiate() as DashboardManager
	
func _ready() -> void:
	AirplaneManagerInstance.ready_constructor(
		plane_start, 
		plane_end,
		interceptor_start,
		interceptor_end
		)
	add_child(AirplaneManagerInstance)
	
	DashboardManagerInstance.ready_constructor(AirplaneManagerInstance)
	add_child(DashboardManagerInstance)
	
func _airplane_manager_ready() -> void:
	AirplaneManagerInstance._test_spawn()

func _process(delta: float) -> void:
	if AirplaneManagerInstance && AirplaneManagerInstance.selected_plane:
		$Layout/FlightDetailsPanel/SpeedValue.text = str(
			AirplaneManagerInstance.selected_plane.air_speed)
	else:
		$Layout/FlightDetailsPanel/SpeedValue.text = "- - - - -"
