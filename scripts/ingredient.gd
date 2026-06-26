class_name DragAndDropSprite extends Sprite2D
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
@onready var button = $Button
# (rarely makes sense, avoid)
# --- Private Onready ---
# --- Public Attributes ---
var id = ""
# --- Private Attributes ---
var _is_dragging = false
var _of = Vector2(0,0)
# --- Public Methods ---
# --- Private Methods ---


# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.size = texture.get_size()
	button.position = -button.size / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_dragging:
		position = get_global_mouse_position() - _of

# --- Debug Methods ---



func _on_button_button_down() -> void:
	_is_dragging = true
	_of = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	_is_dragging = false
