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
	"Burger": {
		"key_taste": ["cooked_patty", "tomato", "onion", "lettuce", "bun_top", "bun_bottom", "cheese"],
		"ingredients": ["cooked_patty", "tomato", "onion", "lettuce", "bun_top", "bun_bottom", "cheese"],
		"sweetness": 2.4,
		"sourness": 1.7,
		"acidity": 2.1,
		"saltiness": 2.4,
		"bitterness": 1.3,
		"umami": 3.3
	}
	
}
# --- Public Onready ---
# (rarely makes sense, avoid)
# --- Private Onready ---
@onready var game_timer: Timer = $GameTimer
@onready var _audio_new_order: AudioStreamPlayer = $AudioNewOrder

@onready var end_screen: Control = $"../CanvasLayer/EndScreen"
@onready var label: Label = $"../CanvasLayer/EndScreen/Label"
@onready var timer_label: Label = $"../CanvasLayer/TimerLabel"
@onready var timer: Timer = $Timer





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
	
	
	

# --- Private Methods ---
func _create_new_order():
	var new_order = Recipe.new()
	var keys = recipes.keys()
	var number = _rng.randi_range(0, 0)
	var recipe_name = keys[number]
	var recipe = recipes[keys[number]]
	var recipe_data = recipes[recipe_name]
	
	new_order.set_recipe(recipe)
	_orders.append(new_order)
	_audio_new_order.play()
	print("Created new Order!")
	
	var order_scene = preload("res://scenes/order.tscn").instantiate()
	add_child(order_scene)
	order_scene.set_order_text(recipe_name, recipe_data["ingredients"])
	


# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rng.randomize()
	_create_new_order()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _passed_time >= _new_order_break:
		_passed_time = _passed_time - _new_order_break
		if randf() <= _new_order_likeliness:
			#_create_new_order()
			pass
	_passed_time = _passed_time + delta
	
	var time_left = timer.time_left
	timer_label.text = str(ceil(time_left))


# --- Debug Methods ---
	
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			var areas = $"../SubmissionArea".get_overlapping_areas()

			for area in areas:
				if area.name == "DishContainerArea":
					print("Submit Order")
					var dish_container := area.get_parent() as DishContainer
					submit_order(dish_container)


func _on_timer_timeout() -> void:
	#Game Over
	print("Evaluating Orders")
	# Evaluate all finished orders
	if not _finished_orders.is_empty() and not _orders.is_empty():
		print("Orders are not empty")
		for i in range(_finished_orders.size()):
			if i > _orders.size():
				break 
			var order: Recipe = _orders[i]
			var finished: Dictionary = _finished_orders[i]
			
			print(order.ingredients)
			for ingredient in finished["ingredients"]:
				print(ingredient.id)
				for ing in order.ingredients:
					if ingredient.id == ing:
						_score += 20
					
			_score += order.acidity - abs(order.acidity - finished["acidity"])
			print("After acidity: ", _score)
			_score += order.sweetness - abs(order.sweetness - finished["sweetness"])
			print("After sweetness: ", _score)
			_score += order.saltness - abs(order.saltness - finished["saltiness"])
			print("After saltiness: ", _score)
			_score += order.sourness - abs(order.sourness - finished["sourness"])
			print("After sourness: ", _score)
			_score += order.bitterness - abs(order.bitterness - finished["bitterness"])
			print("After bitterness: ", _score)
			_score += order.umami - abs(order.umami - finished["umami"])
			print("After umami: ", _score)
					
	print("Score: ", _score)
	end_screen.visible = true
	label.text = str(_score)
	get_tree().paused = true
