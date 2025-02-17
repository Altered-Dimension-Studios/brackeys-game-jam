extends Node2D

class_name Airplane

@export var air_speed = 50000 #km/h
@export var screen_speed = 0
@export var start_distance = 100000 #km
@export var distance = 0

@export var speed_screen_air_factor = 0.01
@export var position_offset = Vector2(0, 20)

@export var markers = [] 
var screen_start
var screen_end
var in_interception: bool

signal plane_clicked

func constructor(_markers: Array, _distance: float = -1) -> void:
	markers = _markers
	screen_start = markers[0].position.x
	screen_end = markers[1].position.x
	if _distance == -1: distance = start_distance
	else: distance = _distance

func _ready() -> void:
	in_interception = false
	#SignalBus.plane_entered_interception.connect(_on_entered_interception)
	#SignalBus.plane_exited_interception.connect(_on_exit_interception)
	

func _process(delta: float) -> void:
	var km_per_second = air_speed / 3600.0
	distance = max((distance - air_speed * delta), 0)
	update_screen_position()

func move_to_marker(marker: Node2D) -> void:
	position = marker.position + position_offset
	
func update_screen_position() -> void:
	if screen_start && screen_end:
		var mapped_pos = remap(distance, start_distance, 0, screen_start, 
			screen_end)
		position = Vector2(mapped_pos, position.y)

func move_to(pos: Vector2) -> void:
	position = pos


func _on_button_pressed() -> void:
	print(emit_signal("plane_clicked"))


func set_intercepted(interception: bool) -> void:
	print("Setting in interception to " + str(interception))
	in_interception = interception
