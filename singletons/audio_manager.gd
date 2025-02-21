extends Node

@export_range(0.0, 10.0) var fade_duration: float = 1.0
@onready var bg_player: AudioStreamPlayer = $BgStreamPlayer

signal on_bg_music_transition_start
signal on_bg_music_transition_end

func fade_out_bg_music():
	var tween: Tween = create_tween()
	
	on_bg_music_transition_start.emit()
	tween.tween_property(
		bg_player,
		"volume_db",
		-80.0,
		fade_duration
	)
	tween.tween_callback(on_bg_music_transition_end.emit)

func fade_in_bg_music():
	bg_player.volume_db = -80.0
	var tween: Tween = create_tween()
	
	on_bg_music_transition_start.emit()
	tween.tween_property(
		bg_player,
		"volume_db",
		0.0,
		fade_duration
	)
	tween.tween_callback(on_bg_music_transition_end.emit)
