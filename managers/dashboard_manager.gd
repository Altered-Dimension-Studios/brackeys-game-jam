extends Node2D

class_name DashboardManager

var AirplaneManagerInstance: AirplaneManager

var destinations_list: Dictionary
var selected_destination: String

func ready_constructor(_AirplaneMnager: AirplaneManager, _destinations_list: Dictionary) -> void:
	AirplaneManagerInstance = _AirplaneMnager
	destinations_list = _destinations_list
	
func _init():
	setup_signals()

func _ready():
	$ItemList.clear()
	for key in destinations_list.keys():
		$ItemList.add_item(key)
	# Mark random destination as selected to avoid crash 
	set_random_destination()

func set_random_destination() -> void:
	var size = destinations_list.size()
	var random_key = destinations_list.keys()[randi() % size]
	selected_destination = random_key

func _process(delta: float) -> void:
	if AirplaneManagerInstance && AirplaneManagerInstance.selected_plane:
		$FlightDetailsPanel/SpeedValue.text = str(
			AirplaneManagerInstance.selected_plane.air_speed)
		$FlightDetailsPanel/HeadingValue.text = str(
			AirplaneManagerInstance.selected_plane.heading)
		$FlightDetailsPanel/DestinationValue.text = AirplaneManagerInstance.selected_plane.destination
	else:
		$FlightDetailsPanel/SpeedValue.text = "- - - - -"
		$FlightDetailsPanel/HeadingValue.text = "- - - - -"
		$FlightDetailsPanel/DestinationValue.text = "- - - - -"

func setup_signals() -> void: 
	SignalBus.plane_clicked.connect(_plane_selected.bind())
	SignalBus.plane_entered_interception.connect(_plane_entered_interception.bind())
	SignalBus.plane_exited_interception.connect(_plane_exited_interception.bind())
	SignalBus.plane_intercepted.connect(_plane_intercepted.bind())
	SignalBus.plane_removed.connect(_plane_removed.bind())

func _on_button_intercept_pressed() -> void:
	if AirplaneManagerInstance._intercept():
		$ButtonIntercept.disabled = true
		$ButtonIntercept/CooldownTimer.start()

func _on_cooldown_timer_timeout() -> void:
	if AirplaneManagerInstance.selected_plane != null && \
	AirplaneManagerInstance.interceptor != null && \
	AirplaneManagerInstance.selected_plane is not Interceptor && \
	AirplaneManagerInstance.selected_plane != AirplaneManagerInstance.interceptor.intercept_target: 
		AirplaneManagerInstance.can_intercept = true
		$ButtonIntercept.disabled = false


func _on_button_fire_pressed() -> void:
	if AirplaneManagerInstance._destroy_intercepted_plane():
		$ButtonIntercept.disabled = true
		$ButtonFire.disabled = true
		$ButtonDivert.disabled = true
		$ButtonAllow.disabled = true

func _plane_removed(plane: Airplane) -> void:
	if AirplaneManagerInstance.selected_plane == plane || \
	AirplaneManagerInstance.num_airplanes == 0:
		$ButtonIntercept.disabled = true
		$ButtonFire.disabled = true
		$ButtonDivert.disabled = true
		$ButtonAllow.disabled = true	
		$ItemList.deselect_all()
		
func _plane_selected(plane: Airplane) -> void:
	if plane is not Interceptor && \
	$ButtonIntercept/CooldownTimer.time_left == 0 && \
	plane.in_interception_area:
		AirplaneManagerInstance.can_intercept = true
		$ButtonIntercept.disabled = false
		
	if plane is not Interceptor:
		$ButtonAllow.disabled = false
		$ButtonDivert.disabled = false
		
func _plane_intercepted(plane: Airplane) -> void:
	$ButtonFire.disabled = false

func _plane_entered_interception(plane: Airplane) -> void:
	if plane is not Interceptor && \
	$ButtonIntercept/CooldownTimer.time_left == 0 && \
	AirplaneManagerInstance.selected_plane == plane:
		$ButtonIntercept.disabled = false

func _plane_exited_interception(plane: Airplane) -> void:
	if AirplaneManagerInstance.selected_plane != null: 
		$ButtonIntercept.disabled = true
		$ButtonFire.disabled = true

func _on_button_allow_pressed() -> void:
	if AirplaneManagerInstance.selected_plane is not Interceptor && \
	AirplaneManagerInstance.allow_plane(AirplaneManagerInstance.selected_plane):
		$ButtonAllow.disabled = true

func _on_button_divert_pressed() -> void:
	AirplaneManagerInstance.selected_plane.order_divert(
		selected_destination, 
		destinations_list[selected_destination])
	$ItemList.deselect_all()

func _on_item_list_item_selected(index: int) -> void:
	selected_destination = $ItemList.get_item_text(index)
