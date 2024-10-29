extends CanvasLayer

func _on_Restart_pressed():
	get_tree().change_scene("res://Scenes/MainGame.tscn")
	GameStatus.can_play = true

func _on_Quit_pressed():
	get_tree().quit()
