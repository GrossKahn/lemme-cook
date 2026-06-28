class_name Order extends Area2D
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
# --- Private Attributes ---
var _is_large: bool = false
var _offset: Vector2 = Vector2(0.0, 0.0)
var _dragging: bool = false
var _mouse_just_pressed: bool = false

# --- Public Methods ---
func set_order_text(recipe_name: String, ingredients: Array) -> void:
	$Label.text = recipe_name + "\n\n"

	for ingredient in ingredients:
		$Label.text += "- " + ingredient + "\n"

# --- Private Methods ---


# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale = Vector2(0.1, 0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _dragging:
		global_position = get_global_mouse_position() + _offset

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		if _is_large:
			self.scale = Vector2(0.1, 0.1)
			_is_large = false
		else:
			self.scale = Vector2(1.0, 1.0)
			_is_large = true
	if event is InputEventMouseButton and not _is_large:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_mouse_just_pressed = true
			_dragging = true
			_offset = global_position - get_global_mouse_position()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_dragging = false

# --- Debug Methods ---
