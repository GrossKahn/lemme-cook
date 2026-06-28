class_name PauseMenu extends Control

@onready var grid_container: GridContainer = $GridContainer
@onready var settings: Panel = $Settings

var _is_paused:bool = false:
	set = set_paused


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self._is_paused = !_is_paused

func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused = value
	visible = value


func _on_resume_btn_pressed() -> void:
	_is_paused = false


func _on_settings_btn_pressed() -> void:
	State.return_scene = "res://scenes/ui/pause_menu.tscn"
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	
