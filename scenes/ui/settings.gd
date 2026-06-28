class_name Settings extends Panel



func _on_back_btn_pressed() -> void:
	if State.return_scene != "":
		get_tree().change_scene_to_file(State.return_scene)
