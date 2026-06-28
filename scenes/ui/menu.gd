class_name Menu extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_button_2_pressed() -> void:
	State.return_scene = "res://scenes/ui/menu.tscn"
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")


func _on_button_3_pressed() -> void:
	get_tree().quit()
