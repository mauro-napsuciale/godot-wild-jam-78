extends CharacterBody2D

enum LETTER_CASE {
	LOWERCASE,
	UPPERCASE
}

enum STATE {
	IDLE,
	MOVING
}

@export_range(1.0, 10.0) var move_speed: float = 5.0
@export_range(5.0, 15.0) var accel_pwr: float = 5.0
@onready var _label: Label = $Label
var enemy_letter_case: LETTER_CASE

var _alphabet: PackedStringArray = [
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
	"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
]
var _current_state: STATE = STATE.IDLE
var _target_ref: Node2D

func _ready() -> void:
	var rand_index: int = randi() % _alphabet.size()
	_label.text = _alphabet[rand_index]
	enemy_letter_case = _resolve_letter_case(_alphabet[rand_index])
	match enemy_letter_case:
		LETTER_CASE.LOWERCASE:
			self.accel_pwr *= randf_range(1.0, 1.25)
		LETTER_CASE.UPPERCASE:
			self.accel_pwr *= randf_range(1.0, 1.15)

func _process(_delta: float) -> void:
	if _target_ref == null:
		_current_state = STATE.IDLE
		return
	_current_state = STATE.MOVING

func _physics_process(delta: float) -> void:
	match(_current_state):
		STATE.IDLE:
			_handle_idle_state(delta)
		STATE.MOVING:
			_handle_move_state(delta)
	move_and_slide()

func _handle_idle_state(delta: float):
	while self.velocity.length() > 0:
		self.velocity = self.velocity.move_toward(Vector2.ZERO, move_speed * delta * Engine.time_scale)
	if _target_ref != null:
		return
	var available_targets = get_tree().get_nodes_in_group("targets")
	if available_targets.size() == 0:
		return
	_target_ref = available_targets[randi() % available_targets.size()]

func _handle_move_state(delta: float):
	var direction: Vector2 = (_target_ref.global_position - self.global_position).normalized()
	self.velocity = direction * pow(move_speed, accel_pwr) * delta * Engine.time_scale

func _resolve_letter_case(letter: String) -> LETTER_CASE:
	if letter >= "A" and letter <= "Z":
		return LETTER_CASE.UPPERCASE
	return LETTER_CASE.LOWERCASE
