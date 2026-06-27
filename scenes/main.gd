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
	
	$Ingredient.setup("tomato", load("res://tomato.png"), 100, 100)
	$DishContainer.setup("pan", load("res://pan.png"), 100, 100)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# --- Debug Methods ---
