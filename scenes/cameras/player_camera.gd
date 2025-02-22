extends Camera2D

enum ZOOM_PRESET {
	CLOSE,
	DEFAULT,
	FAR
}

const preset_vectors = {
	ZOOM_PRESET.CLOSE: Vector2(1.0, 1.0),
	ZOOM_PRESET.DEFAULT: Vector2(0.5, 0.5),
	ZOOM_PRESET.FAR: Vector2(0.25, 0.25),
}

@export_group("Shake settings")
@export_range(0.01, 1.0) var duration:float = 0.5
@export_range(0.0, 256.0) var magnitude: float = 48.0
@export_group("Zoom settings")
@export_range(0.1, 1.0) var transition_duration:float = 0.5
@export var zoom_preset: ZOOM_PRESET = ZOOM_PRESET.DEFAULT

var _is_shaking: bool = false;
var _elapsed_time:float = 0.0

signal shake_start
signal shake_end

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	if (_is_shaking != true):
		return

	self.shake_start.emit()
	if _elapsed_time < duration * Engine.time_scale:
		var shake_offset = Vector2(
		randf_range(-magnitude, magnitude),
		randf_range(-magnitude, magnitude),
		)
		_elapsed_time += delta * Engine.time_scale
		self.offset = shake_offset
		await get_tree().process_frame
		return
	self.offset = Vector2(0,0)
	_is_shaking = false
	self.shake_end.emit()

func shake(custom_duration: float = duration, custom_magnitude: float = magnitude) -> void:
	var original_duration: float = duration
	var original_magnitue: float = magnitude
	if custom_duration != duration:
		duration = custom_duration
	if custom_magnitude != magnitude:
		magnitude = custom_magnitude
	_is_shaking = true
	await self.shake_end
	duration = original_duration
	magnitude = original_magnitue

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_down") != true:
		return
	cycle_zoom()

func cycle_zoom()-> void:
	if zoom_preset == ZOOM_PRESET.CLOSE:
		zoom_preset = ZOOM_PRESET.DEFAULT
	elif zoom_preset == ZOOM_PRESET.DEFAULT:
		zoom_preset = ZOOM_PRESET.FAR
	else:
		zoom_preset = ZOOM_PRESET.CLOSE
	self.zoom = preset_vectors[zoom_preset]
