class_name Main extends Node2D
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

# --- Public Methods ---
# --- Private Methods ---


# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Ingredient2.setup("tomaaaaaaaaaaaaaato", load("res://tomato.png"), 200, 200)
	$Ingredient.setup("tomato", load("res://tomato.png"), 100, 100)
	$DishContainer.setup("pan", load("res://pan.png"), 100, 100)
	$Ingredient.set_acidity(5)
	$Ingredient.set_sweetness(2)
	$Ingredient.set_saltness(-2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _createIngredient(id: String, node_name: String, texture_path: String, width: float, height: float, sweetness: float, acidity: float, sourness: float, saltness: float, bitterness: float, umami: float) -> void:
	var ingredient = preload("res://scenes/ingredient.tscn").instantiate()
	add_child(ingredient)
	ingredient.name = node_name
	ingredient.setup(id, load(texture_path), width, height)
	
func _createDishContainer(id: String, node_name: String, texture_path: String, width: float, height: float) -> void:
	var dish_container = preload("res://scenes/dishContainer.tscn").instantiate()
	add_child(dish_container)
	dish_container.name = node_name
	dish_container.setup(id, load(texture_path), width, height)


	

# --- Debug Methods ---
