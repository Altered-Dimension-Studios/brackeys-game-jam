extends Node2D

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
	$Description.text = "--------------"

func _on_plane_selected(plane: Airplane) -> void:
	update_log_panel_plane_data(plane)
