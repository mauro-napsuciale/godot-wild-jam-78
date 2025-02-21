extends CanvasLayer

func _on_start_button_pressed() -> void:
	SceneTransition.fade_to_scene(SceneTransition.SCENE_KEYS.TUTORIAL)
