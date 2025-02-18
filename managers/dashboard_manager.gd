extends Node2D

class_name DashboardManager

var AirplaneManagerInstance: AirplaneManager

func ready_constructor(_AirplaneMnager: AirplaneManager) -> void:
	AirplaneManagerInstance = _AirplaneMnager

func _init():
	setup_signals()

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
	if plane is Interceptor:
		AirplaneManagerInstance.can_intercept = true

func _on_button_allow_pressed() -> void:
	if AirplaneManagerInstance.selected_plane is not Interceptor && \
	AirplaneManagerInstance.allow_plane(AirplaneManagerInstance.selected_plane):
		$ButtonAllow.disabled = true
