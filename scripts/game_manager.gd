class_name GameManager extends Node
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

var recipes = {
	"Nudeln mit Pesto": {
		"key_taste": ["herbal", "savory", "rich"],
		"ingredients": ["noodles", "pesto"],
		"sweetness": 0.2,
		"sourness": 0.0,
		"acidity": 0.3,
		"saltiness": 0.7,
		"bitterness": 0.4,
		"umami": 0.6
	},

	"Pizza": {
		"key_taste": ["savory", "cheesy", "tomato"],
		"ingredients": ["dough", "tomato", "cheese"],
		"sweetness": 0.4,
		"sourness": 0.0,
		"acidity": 0.6,
		"saltiness": 0.7,
		"bitterness": 0.1,
		"umami": 0.8
	},
	
}
# --- Public Onready ---
# (rarely makes sense, avoid)
# --- Private Onready ---
# --- Public Attributes ---
# --- Private Attributes ---


var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

var _orders: Array[Ingredient]
# duration of break between orders in s
const _new_order_break: float = 5.0
# how likely it is that a new order spawns every time _new_order_break passes
const _new_order_likeliness: float = 0.5
var _passed_time: float = 0.0

# --- Public Methods ---
func submit_order(order: DishContainer):
	pass

# --- Private Methods ---
func _create_new_order():
	var new_order = Ingredient.new()
	var keys = recipes.keys()
	var number = _rng.randi_range(0, 1)
	var recipe = recipes[keys[number]]
	print(recipe)
	
	new_order.set_recipe(recipe)
	print(new_order.key_taste)



# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _passed_time >= _new_order_break:
		_passed_time = _passed_time - _new_order_break
		if randf() <= _new_order_likeliness:
			_create_new_order()
	_passed_time = _passed_time + delta

# --- Debug Methods ---
