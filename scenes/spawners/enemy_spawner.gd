extends Node2D

@export var enemy_scene: PackedScene
@export var level_config: Node2D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var _spawn_enabled: bool = false
var _spawning: bool = false
var _current_amount: int = 0
var _current_wave: int = 0

func _ready() -> void:
	SignalBus.on_wave_start.connect(_on_wave_start)
	SignalBus.on_wave_end.connect(_on_wave_end)

func _process(delta: float) -> void:
	if _spawn_enabled == false or _spawning == true:
		return
	_spawning = true
	var to_wait = level_config.spawn_rate_curve.sample(float(_current_wave))
	var timer = get_tree().create_timer(to_wait)
	await timer.timeout
	prints('waited', to_wait)
	spawn_enemies()
	_spawning = false

func spawn_enemies():
	if enemy_scene == null:
		printerr("Enemy scene was not set for spawner " + self.name)
		return
	for enemy in _current_amount:
		var new_enemy = enemy_scene.instantiate()
		add_child(new_enemy)
		new_enemy.global_position = self.global_position

func _on_wave_start():
	_current_wave = level_config.current_wave
	_current_amount = floori(level_config.spawn_amount_curve.sample(level_config.current_wave))
	_spawn_enabled = true
	prints(_current_wave, _current_amount)

func _on_wave_end():
	_spawn_enabled = false
