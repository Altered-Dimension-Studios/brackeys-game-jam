extends Node2D


func _on_blue_area_2d_area_entered(area: Area2D) -> void:
	var plane: Airplane = area.get_parent()
	plane.set_intercepted(true)
	SignalBus.plane_entered_interception.emit()
	print("Plane entered interception")


func _on_blue_area_2d_area_exited(area: Area2D) -> void:
	var plane: Airplane = area.get_parent()
	plane.set_intercepted(false)
	
	if plane is Interceptor:
		plane.free()
	SignalBus.plane_exited_interception.emit()
	print("Plane exited interception area")


func _on_dead_area_2d_area_entered(area: Area2D) -> void:
	SignalBus.plane_entered_dead_zone.emit()
	print("Plane entered dead zone")
