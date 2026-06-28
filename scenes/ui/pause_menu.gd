class_name PauseMenu extends Control

@onready var grid_container: GridContainer = $GridContainer
@onready var settings: Panel = $Settings

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = get_tree().paused
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var new_state = not get_tree().paused
		get_tree().paused = new_state
		visible = new_state

func set_paused(value:bool) -> void:
	get_tree().paused = value
	visible = value


func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_settings_btn_pressed() -> void:
	State.return_scene = "res://scenes/Main.tscn"
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")


func _on_quit_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
	
