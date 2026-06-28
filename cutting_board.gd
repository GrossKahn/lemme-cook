class_name CuttingBoard extends Node2D
## Brief class description
##
## Class description main body
##
## Footer, user for tags, for more information see https://git.lachanas.de/MECHAphant/cannonclabauter/wiki/Coding-Conventions
## @experimental example 

# --- Signals ---
# --- Constants ---
# --- Enums --- (uppercase, no policy on visibility)
# --- Public Exports ---
# --- Private Exports ---
# --- Public Onready ---
# (rarely makes sense, avoid)
# --- Private Onready ---
# --- Public Attributes ---
var can_cut: bool
# --- Private Attributes ---
@onready var _audio_cutting: AudioStreamPlayer2D = $AudioCutting
# --- Public Methods ---
# --- Private Methods ---


# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# --- Debug Methods ---


func _on_cutting_board_area_area_entered(area: Area2D) -> void:
	if area.name == "KnifeArea":
		print("Can Cut")
		_audio_cutting.play()
		can_cut = true


func _on_cutting_board_area_area_exited(area: Area2D) -> void:
	if area.name == "KnifeArea":
		print("Cant Cut")
		can_cut = false
