class_name Ingredient extends Node2D
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
var id: String

var sweetness = 0.0
var acidity = 0.0
var sourness = 0.0
var saltness = 0.0
var bitterness = 0.0
var umami = 0.0
# --- Private Attributes ---
var _dragging = false
var _offset = Vector2(0,0)

var _sprite: Sprite2D
# --- Public Methods ---
# --- Private Methods ---


# --- Private Engine Methods---


func setup(ingredient_id: String, texture: Texture2D, width: float, height: float) -> void:
	id = ingredient_id
	_sprite = Sprite2D.new()
	_sprite.texture = texture
	
	
	add_child(_sprite)
	set_size(width, height)
	$IngredientArea/CollisionShape2D.shape.extents = Vector2(width/2, height/2)
	
func set_sweetness(value: float) -> void:
	sweetness = value
	
func set_acidity(value: float) -> void:
	acidity = value

func set_sourness(value: float) -> void:
	sourness = value
	
func set_saltness(value: float) -> void:
	saltness = value
	
func set_bitterness(value: float) -> void:
	bitterness = value
	
func set_umami(value: float) -> void:
	umami = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$IngredientArea.input_event.connect(_on_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _dragging:
		global_position = get_global_mouse_position() + _offset


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_dragging = true
			_offset = global_position - get_global_mouse_position()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_dragging = false
# --- Debug Methods ---



func set_size(width: float, height: float) -> void:
	var tex_size = _sprite.texture.get_size()

	_sprite.scale = Vector2(
		width / tex_size.x,
		height / tex_size.y
	)
