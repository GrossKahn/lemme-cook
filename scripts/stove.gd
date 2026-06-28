class_name Stove extends Area2D


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		$AudioOvenOpening.play()
