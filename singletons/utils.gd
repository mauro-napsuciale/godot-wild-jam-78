extends Node
# Globally available enums, functions and variables
@export_group("Slow motion settings")
@export_range(0.0, 1.0) var slow_motion_defualt_timescale = 0.25
@export_range(0.01, 1.0) var slow_motion_default_duration = 0.25

func slow_motion(duration: float = slow_motion_default_duration, time_scale: float = slow_motion_defualt_timescale):
	Engine.time_scale = time_scale
	print("slowmo start", time_scale)
	await get_tree().create_timer(duration * time_scale).timeout
	print("slowmo end")
	Engine.time_scale = 1.0
