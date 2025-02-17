extends Node

func spawn_airplane():
	var airplane_details = PlanesDatabase.get_random_plane()
	# Instantiate Airplane and attach details from DB on it
	# We'll need to mix and match some values from DB to give false information about planes
	# Control whole airplane flow from manager. This means:
		# Spawn airplane on timer
		# Handle all possible cases. We should add an enum: INTERCEPT, DIVERT, FIRE, ALLOW
		# Play animations and sounds on airplane
		
func spawn_intercepter():
	# Same as airplane but for intercepter
	pass
