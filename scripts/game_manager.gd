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
# --- Public Onready ---
# (rarely makes sense, avoid)
# --- Private Onready ---
# --- Public Attributes ---
# --- Private Attributes ---

# var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

var _orders: Array[Ingredient]
# duration of break between orders in s
const _new_order_break: float = 150.0
# how likely it is that a new order spawns every time _new_order_break passes
const _new_order_likeliness: float = 0.5
var _passed_time: float = 0.0

# --- Public Methods ---
func submit_order(order: DishContainer):
	pass

# --- Private Methods ---
func _create_new_order():
	var new_order = Ingredient.new()



# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _passed_time >= _new_order_break:
		_passed_time = _passed_time - _new_order_break
		if randf() <= _new_order_likeliness:
			_create_new_order()
	_passed_time = _passed_time + delta

# --- Debug Methods ---

