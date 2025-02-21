extends CanvasLayer

@export var fade_color = Color.BLACK
@export var fade_duration: float = 1.0

@onready var color_rect: ColorRect = null

signal on_fade_in_start
signal on_fade_in_end
signal on_fade_out_start
signal on_fade_out_end

var main_scene_key: String = "main_scene_key"
var tutorial_scene_key: String = "tutorial_scene_key"

enum SCENE_KEYS {
	MAIN,
	TUTORIAL
}

var scenes = {
	SCENE_KEYS.MAIN: "res://scenes/main.tscn",
	SCENE_KEYS.TUTORIAL: "res://scenes/levels/tutorial.tscn"
}

func _ready():
	color_rect = get_node_or_null("FadeRect")
	if color_rect == null:
		_initialize_color_rect()

func _initialize_color_rect():
	color_rect = ColorRect.new()
	color_rect.name = "FadeRect"
	self.add_child(color_rect)
	
	var viewport: Viewport = get_viewport()
	
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
	var viewport: Viewport = get_viewport()
	if color_rect == null:
		_initialize_color_rect()
	color_rect.size = viewport.get_visible_rect().size

func fade_in():
	var tween: Tween = create_tween()
	
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
	var tween: Tween = create_tween()
	
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

func fade_to_scene(scene_key: SCENE_KEYS):
	if scene_key == null:
		printerr("Scene key is required for transition")
		return;
	var path = scenes.get(scene_key)
	
	if path == null:
		printerr(scene_key ,"Invalid scene key. It does not exist in the scenes dictionary")
		return
	var packed_scene: PackedScene = load(path)
	fade_out()
	await on_fade_out_end
	var tree = get_tree()
	var change_res = tree.change_scene_to_packed(packed_scene)
	if change_res != OK:
		printerr("Failed to transition to provided key", scene_key)
		return
	fade_in()
