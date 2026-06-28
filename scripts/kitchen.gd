class_name Kitchen extends Area2D
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
@onready var ingredient_list: Node2D = $"../IngredientList"

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
			$AudioOpenClose.play()
			_lowpass_filter.cutoff_hz=20000
			_is_open = false
			var areas = $IsInFridgeArea.get_overlapping_areas()
			for area in areas:
				if area.name == "IngredientArea":
					area.get_parent().visible = true
				
			
			
				
		else:
			$AudioOpenClose.play()
			_lowpass_filter.cutoff_hz=600
			_is_open = true
			var areas = $IsInFridgeArea.get_overlapping_areas()
			for area in areas:
				if area.name == "IngredientArea":
					area.get_parent().visible = false
	


# --- Debug Methods ---
