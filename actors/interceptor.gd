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
	if intercept_target && intercept_target is not Interceptor:
		if intercept_target.distance < self.distance:
			air_speed = max_air_speed
		elif intercept_target.distance > self.distance:
			air_speed = -max_air_speed
		else:
			air_speed = intercept_target.air_speed
	else: 
		air_speed = cruise_air_speed

func _on_button_pressed() -> void:
	super()
