extends Node

@export_group("Wave config")
@export var current_wave: int
@export var total_waves: int
@export_group("Behavior curves")
@export_subgroup("Spawn behaviors")
@export var spawn_rate_curve: Curve
@export var spawn_amount_curve: Curve
@export_subgroup("Duration behaviors") 
@export var wave_rest_time: Curve

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_released("ui_cancel") != true:
		return
	_start_level()

func _start_level():
	SignalBus.on_wave_start.emit()
