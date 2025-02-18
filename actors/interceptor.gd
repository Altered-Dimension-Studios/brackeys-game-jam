extends Airplane

class_name Interceptor

var intercept_target: Airplane
var cruise_air_speed = 600

func _ready() -> void:
	super()
	air_speed = 1000
	max_air_speed = 2000
	min_air_speed = 300
	position_offset = Vector2(0, -20)

func _process(delta: float) -> void:
	super(delta)
	handle_air_speed()
	
func handle_air_speed() -> void:
	if intercept_target != null && intercept_target is not Interceptor:
		var distance_diff = abs(intercept_target.distance - distance)
		
		if distance_diff > 10:
			if intercept_target.distance < distance:
				air_speed = max_air_speed
				rotation_degrees = 0
			elif intercept_target.distance > distance:
				air_speed = -max_air_speed
				rotation_degrees = 180
		else:
			distance = intercept_target.distance
			air_speed = intercept_target.air_speed
			rotation_degrees = intercept_target.rotation_degrees
			SignalBus.plane_intercepted.emit(intercept_target)
	else: 
		air_speed = cruise_air_speed

func _on_button_pressed() -> void:
	super()
