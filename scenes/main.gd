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
class TasteParameters:
	var key_taste: String
	var sweetness: float
	var acidity: float
	var sourness: float
	var saltness: float
	var bitterness: float
	var umami: float
	
class Dish:
	var key_taste = []
	var sweetness: float
	var acidity: float
	var sourness: float
	var saltness: float
	var bitterness: float
	var umami: float
# --- Private Exports ---
# --- Public Onready ---
# (rarely makes sense, avoid)
# --- Private Onready ---
# --- Public Attributes ---
# --- Private Attributes ---

# --- Public Methods ---

func get_ingredient_root():
	return $IngredientList

func get_knife():
	return  %Knife

#--- Private Methods ---


# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$IngredientList/Tomato.setup(
		"tomato",
		load("res://assets/ingredients/tomato-psx.png"),
		100, 100,
		["tomato"] as Array[String],
		0.2, 0.7, 0.3, 0.1, 0.1, 0.5
	)

	$IngredientList/Lettuce.setup(
		"lettuce",
		load("res://assets/ingredients/lettuce-psx.png"),
		100, 100,
		["lettuce"] as Array[String],
		0.3, 0.2, 0.2, 0.1, 0.1, 0.1
	)

	$IngredientList/BunBottom.setup(
		"bun_bottom",
		load("res://assets/ingredients/bun-bot-psx.png"),
		100, 100,
		["bun_bottom", "bread"] as Array[String],
		0.6, 0.2, 0.1, 0.5, 0.1, 0.4
	)

	$IngredientList/BunTop.setup(
		"bun_top",
		load("res://assets/ingredients/bun-top-psx.png"),
		100, 100,
		["bun_top", "bread"] as Array[String],
		0.6, 0.2, 0.1, 0.5, 0.1, 0.4
	)

	$IngredientList/Cheese.setup(
		"cheese",
		load("res://assets/ingredients/cheese-psx.png"),
		100, 100,
		["cheese"] as Array[String],
		0.3, 0.1, 0.1, 0.6, 0.1, 0.8
	)

	$IngredientList/PattyUncooked.setup(
		"patty_uncooked",
		load("res://assets/ingredients/patty-uncooked-psx.png"),
		100, 100,
		["meat", "patty_uncooked"] as Array[String],
		0.2, 0.1, 0.1, 0.4, 0.2, 0.9
	)

	$IngredientList/Onion.setup(
		"onion",
		load("res://assets/ingredients/onion-psx.png"),
		100, 100,
		["onion"] as Array[String],
		0.2, 0.6, 0.8, 0.2, 0.6, 0.2
	)
	
	$Pan.setup("pan", load("res://assets/appliance/pan.png"), 100, 100)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _createIngredient(id: String, node_name: String, texture_path: String, width: float, height: float, taste_parameters: TasteParameters) -> void:
	var ingredient = preload("res://scenes/ingredient.tscn").instantiate()
	add_child(ingredient)
	ingredient.name = node_name
	ingredient.setup(id, load(texture_path), width, height)
	
func _createDishContainer(id: String, node_name: String, texture_path: String, width: float, height: float) -> void:
	var dish_container = preload("res://scenes/dishContainer.tscn").instantiate()
	add_child(dish_container)
	dish_container.name = node_name
	dish_container.setup(id, load(texture_path), width, height)
	
func check_dish(dish: Dish, dish_container: DishContainer) -> void:
	pass


	

# --- Debug Methods ---
