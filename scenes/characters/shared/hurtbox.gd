extends Area2D

signal damage_received

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func on_attack_request() -> void:
	var areas: Array[Area2D] = get_overlapping_areas()
	for a in areas:
		var angle = get_angle_to(a.global_position)
		
