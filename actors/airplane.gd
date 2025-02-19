extends Node2D

class_name Airplane

@export var max_air_speed = 1000
@export var min_air_speed = 300
@export var max_distance = 100000 #km
@export var position_offset = Vector2(0, 20)
@export var update_rate = 0.6
@export var heading_change_rate = 0.1
var max_heading = 360
var markers = [] 
var screen_start
var screen_end

@export var distance = 0
@export var air_speed = 800 #km/h
@export var destination = "LAX"
@export var departure = "IAS"
@export var heading = 123
@export var flight_number = "432"

var target_heading = -1

var in_interception_area: bool

signal plane_clicked

func constructor(_markers: Array, _max_distance: float, _distance: float = -1) -> void:
	markers = _markers
	screen_start = markers[0].position.x
	screen_end = markers[1].position.x
	max_distance = _max_distance
	if _distance == -1: distance = _max_distance
	else: distance = _distance
	

func _ready() -> void:
	in_interception_area = false

func _process(delta: float) -> void:
	var km_per_second = air_speed / 3600.0
	distance = max((distance - air_speed * delta), 0)
	
	update_screen_position()
	update_heading()

func move_to_marker(marker: Node2D) -> void:
	position = marker.position + position_offset
	distance = remap(marker.position.x, screen_end, screen_start, 0, max_distance)
	
	
func update_screen_position() -> void:
	if screen_start && screen_end:
		var mapped_pos = remap(distance, max_distance, 0, screen_start, 
			screen_end)
		position = Vector2(mapped_pos, position.y)
		
func update_heading() -> void:
	if target_heading != -1:
		if int(heading) < target_heading:
			heading += heading_change_rate
		elif int(heading) > target_heading:
			heading -= heading_change_rate

func _on_button_pressed() -> void:
	SignalBus.plane_clicked.emit(self)

func set_in_interception_area(interception: bool) -> void:
	#print("Setting in interception area to " + str(interception))
	in_interception_area = interception
	
func order_divert(new_destination: String, heading: int) -> void:
	destination = new_destination
	target_heading = heading
