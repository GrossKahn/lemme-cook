class_name Kitchen extends Area2D
## Brief class description
##
## Class description main body
##
## Footer, user for tags, for more information see https://git.lachanas.de/MECHAphant/cannonclabauter/wiki/Coding-Conventions
## @experimental example 

# --- Signals ---
# --- Constants ---
const _FRIDGE_OPEN_SOUND = preload("res://assets/sound/fridge_open.mp3")
const _FRIDGE_CLOSE_SOUND = preload("res://assets/sound/fridge-close.mp3")
# --- Enums --- (uppercase, no policy on visibility)
# --- Public Exports ---
# --- Private Exports ---
# --- Public Onready ---
# (rarely makes sense, avoid)
# --- Private Onready ---
# --- Public Attributes ---
# --- Private Attributes ---
var _is_open: bool = false 
var _lowpass_filter : AudioEffectLowPassFilter = AudioEffectLowPassFilter.new()
# --- Public Methods ---
# --- Private Methods ---


# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.add_bus_effect(1,_lowpass_filter,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_open:
		$Sprite2D.set_frame(0)
	else:
		$Sprite2D.set_frame(1)
		
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		if _is_open:
			$AudioOpenClose.stream = _FRIDGE_CLOSE_SOUND
			$AudioOpenClose.play()
			_lowpass_filter.cutoff_hz=20000
			_is_open = false
		else:
			$AudioOpenClose.stream = _FRIDGE_OPEN_SOUND
			$AudioOpenClose.play()
			_lowpass_filter.cutoff_hz=600
			_is_open = true
	


# --- Debug Methods ---
