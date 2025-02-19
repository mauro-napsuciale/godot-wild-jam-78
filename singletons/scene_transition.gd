extends CanvasLayer

@export var fade_color = Color.BLACK
@export var fade_duration = 1.0

@onready var color_rect: ColorRect = null

signal on_fade_in_start
signal on_fade_in_end
signal on_fade_out_start
signal on_fade_out_end

func _ready():
	color_rect = get_node_or_null("FadeRect")
	if color_rect == null:
		_initialize_color_rect()

func _initialize_color_rect():
	color_rect = ColorRect.new()
	color_rect.name = "FadeRect"
	self.add_child(color_rect)
	
	var viewport = get_viewport()
	
	color_rect.name = "FadeRect"  
	color_rect.color = fade_color
	color_rect.size = viewport.get_visible_rect().size 
	color_rect.anchor_top = 0
	color_rect.anchor_bottom = 1
	color_rect.anchor_left = 0
	color_rect.anchor_right = 1
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.color.a = 1.0
	viewport.connect("size_changed", _on_viewport_resized)

func _on_viewport_resized():
	var viewport = get_viewport()
	if color_rect == null:
		_initialize_color_rect()
	color_rect.size = viewport.get_visible_rect().size

func fade_in():
	var tween = create_tween()
	
	if color_rect == null:
		_initialize_color_rect()
	
	on_fade_in_start.emit()
	tween.tween_property(
		color_rect,
		"color:a",
		0.0,
		fade_duration
	)
	tween.tween_callback(on_fade_in_end.emit)

func fade_out():
	var tween = create_tween()
	
	if color_rect == null:
		_initialize_color_rect()
	
	on_fade_out_start.emit()
	tween.tween_property(
		color_rect,
		"color:a",
		1.0,
		fade_duration
	)
	tween.tween_callback(on_fade_out_end.emit)
