class_name DishContainer extends Node
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
var heat = 0.0
var is_boiling = false
var ingredients = []


var id: String
# --- Private Attributes ---
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
	$DishContainerArea/CollisionShape2D.shape.extents = Vector2(width/2, height/2)
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# --- Debug Methods ---
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			var areas = $DishContainerArea.get_overlapping_areas()

			for area in areas:
				if area.name == "IngredientArea":
					print("Ingredient eingesammelt")
					var parent = area.get_parent()
					ingredients.append(parent.id)
					parent.queue_free()
					print(ingredients)
					
					
func set_size(width: float, height: float) -> void:
	var tex_size = _sprite.texture.get_size()

	_sprite.scale = Vector2(
		width / tex_size.x,
		height / tex_size.y
	)
