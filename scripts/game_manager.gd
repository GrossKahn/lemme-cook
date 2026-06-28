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
@onready var game_timer: Timer = $GameTimer
# --- Public Attributes ---
# --- Private Attributes ---
var _score: float

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

var _orders: Array[Recipe]
var _finished_orders: Array
# duration of break between orders in s
const _new_order_break: float = 5.0
# how likely it is that a new order spawns every time _new_order_break passes
const _new_order_likeliness: float = 0.5
var _passed_time: float = 0.0

# --- Public Methods ---
func submit_order(order: DishContainer):
	print(order.id)
	if order.ingredients.is_empty() == false:
		_finished_orders.append({
			"id": order.id,
			"ingredients": order.ingredients.duplicate(),
			"acidity": order.acidity,
			"saltiness": order.saltness,
			"sweetness": order.sweetness,
			"bitterness": order.bitterness,
			"umami": order.umami,
			"sourness": order.sourness,
			"key_taste": order.key_tasteness.duplicate()
		})
	order.ingredients = []
	order.acidity = 0.0
	order.saltness = 0.0
	order.sweetness = 0.0
	order.bitterness = 0.0
	order.umami = 0.0
	order.sourness = 0.0
	for o in _finished_orders:
		print(o.ingredients)
	
	
	

# --- Private Methods ---
func _create_new_order():
	var new_order = Recipe.new()
	var keys = recipes.keys()
	var number = _rng.randi_range(0, 1)
	var recipe = recipes[keys[number]]
	print(recipe)
	
	new_order.set_recipe(recipe)
	print(new_order.key_taste)
	_orders.append(new_order)


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


func _on_game_timer_timeout() -> void:
	#Game Over
	# Evaluate all finished orders
	if not _finished_orders.is_empty() and not _orders.is_empty():
		for i in range(_finished_orders.size()):
			var order: Recipe = _orders[i]
			var finished: Dictionary = _finished_orders[i]

			if order.ingredients == finished["ingredients"]:
				_score += 20
			else:
				_score -= 20
			
			_score += order.acidity - abs(order.acidity - finished["acidity"])
			_score += order.sweetness - abs(order.sweetness - finished["sweetness"])
			_score += order.saltness - abs(order.saltness - finished["saltiness"])
			_score += order.sourness - abs(order.sourness - finished["sourness"])
			_score += order.bitterness - abs(order.bitterness - finished["bitterness"])
			_score += order.umami - abs(order.umami - finished["umami"])
			
			for key_taste in order.key_taste:
				if finished["key_taste"].has(key_taste):
					_score += 10
				else:
					_score -= 10
					
	print("Score: ", _score)
	
	

		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			var areas = $"../SubmissionArea".get_overlapping_areas()

			for area in areas:
				if area.name == "DishContainerArea":
					print("Submit Order")
					var dish_container := area.get_parent() as DishContainer
					submit_order(dish_container)
