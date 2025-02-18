extends Node2D


func _on_blue_area_2d_area_entered(area: Area2D) -> void:
	var plane: Airplane = area.get_parent()
	plane.set_in_interception_area(true)
	SignalBus.plane_entered_interception.emit()
	#print("Plane entered interception")


func _on_blue_area_2d_area_exited(area: Area2D) -> void:
	var plane: Airplane = area.get_parent()
	plane.set_in_interception_area(false)
	
	if plane is Interceptor:
		SignalBus.plane_removed.emit(plane)
		plane.free()
		
	SignalBus.plane_exited_interception.emit()
	#print("Plane exited interception area")


func _on_noreturn_area_2d_area_entered(area: Area2D) -> void:
	var plane: Airplane = area.get_parent()
	SignalBus.plane_removed.emit(plane)
	plane.free() #temp

	SignalBus.plane_entered_noreturn_zone.emit()
	#print("Plane entered no return zone")
