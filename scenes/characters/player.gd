extends CharacterBody2D

enum STATE {
	IDLE,
	MOVE,
	ATTACK,
	DASH
}

@export_range(1.0, 10.0) var move_speed: float = 5.0
@export_range(5.0, 15.0) var accel_pwr: float = 7.0
@export_range(1.0, 10.0) var dash_pwr: float = 5.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var _input_vector: Vector2 = Vector2.ZERO
var _current_state: STATE = STATE.IDLE

func _input(event: InputEvent) -> void:
	if event.is_action_released("attack"):
		_current_state = STATE.ATTACK

func _process(_delta: float) -> void:
	_input_vector = _get_move_vector()

func _physics_process(delta: float) -> void:
	if _current_state == STATE.ATTACK:
		_handle_attack_state(delta)
		return
	
	if _input_vector.length() > 0:
		_current_state = STATE.MOVE
	else:
		_current_state = STATE.IDLE
	
	match(_current_state):
		STATE.IDLE:
			_handle_idle_state(delta)
		STATE.MOVE:
			_handle_move_state(delta)
		STATE.ATTACK:
			_handle_attack_state(delta)
	move_and_slide()

func _get_move_vector() -> Vector2:
	return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()

func _handle_move_state(delta: float):
	_current_state = STATE.MOVE
	animation_player.speed_scale = 3.0
	animation_player.play("idle")
	self.velocity = _input_vector * pow(move_speed, accel_pwr) * delta * Engine.time_scale
	if _input_vector.x >= 0:
		sprite.flip_h = false
		return
	sprite.flip_h = true

func _handle_idle_state(delta: float):
	_current_state = STATE.IDLE
	animation_player.speed_scale = 1.0
	animation_player.play("idle")
	while self.velocity.length() > 0:
		self.velocity = self.velocity.move_toward(Vector2.ZERO, move_speed * delta * Engine.time_scale)

func _handle_attack_state(delta: float):
	_current_state = STATE.ATTACK
	self.velocity = _input_vector * pow(move_speed, accel_pwr) * delta * Engine.time_scale
	animation_player.speed_scale = 1.0
	animation_player.play("attack")
	await animation_player.animation_finished
	_current_state = STATE.IDLE
