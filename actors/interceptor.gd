extends Airplane

class_name Interceptor



func _ready() -> void:
	super()
	air_speed = 1500
	position_offset = Vector2(0, -20)


func _process(delta: float) -> void:
	super(delta)

func _on_button_pressed() -> void:
	super()
