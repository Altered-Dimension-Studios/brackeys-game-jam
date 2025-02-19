extends Node2D

var selected_plane: Airplane

func _init() -> void:
	SignalBus.plane_clicked.connect(_on_plane_selected.bind())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_log_panel_plane_data(plane: Airplane) -> void:
	$Description.text = "Flight %s, %s - %s" % [plane.flight_number, plane.departure, plane.destination]

func clear_log_panel() -> void:
	selected_plane = null
	$Description.text = "--------------"

func _on_plane_selected(plane: Airplane) -> void:
	selected_plane = plane
	update_log_panel_plane_data(plane)


func _on_flight_status_button_pressed() -> void:
	$LogText.append_text("ATC: Flight status\n")
	var response = "Flight %s: %s\n" % [selected_plane.flight_number, selected_plane.get_flight_check_repsonse()]
	$LogText.append_text(response)


func _on_code_button_pressed() -> void:
	$LogText.append_text("ATC: Emergency code check\n")
	var response = "Flight %s: %s\n" % [selected_plane.flight_number, selected_plane.get_code_check_repsonse()]
	$LogText.append_text(response)
