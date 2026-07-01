class_name DishContainer extends Node2D
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
# --- Public Attributes ---
var heat = 0.0
var is_boiling = false
var ingredients = []

var sweetness = 0.0
var acidity = 0.0
var sourness = 0.0
var saltness = 0.0
var bitterness = 0.0
var umami = 0.0

var key_tasteness = []

var darkness = 1.0

var id: String
# --- Private Attributes ---
var _sprite: Sprite2D
var _dragging = false
var _offset = Vector2(0,0)
var _heating = false
var _last_time := 0.0
var _sizzling = true
var _oven_done_played = false
@onready var _audio_pick_up: AudioStreamPlayer2D = $AudioPickUp
@onready var _audio_leave_item: AudioStreamPlayer2D = $AudioLeaveItem
@onready var _audio_sizzling: AudioStreamPlayer2D = $AudioSizzling
@onready var _audio_oven_end: AudioStreamPlayer2D = $AudioOvenEnd
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
	$DishContainerArea.input_event.connect(_on_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	
	if current_time - _last_time >= 0.3:
		_last_time = current_time
		if _heating and heat <= 200:
			heat += 5
			print(heat)
			
			check_for_patty()
			if heat >= 200 and not _oven_done_played:
				_audio_oven_end.play()
				_oven_done_played = true
		else:
			if heat > 0:
				heat -= 1
				print(heat)
				if heat < 100:
					_oven_done_played = false
		
	if _dragging:
		global_position = get_global_mouse_position() + _offset
		
	
		

func check_for_patty() -> void:
	for ingredient in ingredients:
		if ingredient.id == "patty_uncooked" and heat > 150:
			ingredient.setup("cooked_patty",
			load("res://assets/ingredients/patty-cooked-psx.png"), 
			100,
			100,
			["meat", "cooked"] as Array[String],
			ingredient.sweetness,
			ingredient.acidity,
			ingredient.sourness,
			ingredient.saltness,
			ingredient.bitterness,
			ingredient.umami)
			ingredient._polygon2d.color = Color(1.0, 1.0, 1.0)
			
		if ingredient.id == "patty_uncooked":
			if _sizzling:
				_audio_sizzling.play()
			_sizzling = false
			
			var t = clamp(heat / 200.0, 0.0, 1.0)
			ingredient._polygon2d.color = Color(1.0 - t, 1.0 - t, 1.0 - t)

# --- Debug Methods ---
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			var areas = $DishContainerArea.get_overlapping_areas()

			for area in areas:
				if area.name == "IngredientArea":
					var ingredient = area.get_parent()

					# Zustand speichern
					ingredient._container = self
					ingredient._in_container = true

					# in Container ziehen (Position bleibt gleich)
					ingredient.reparent(self, true)

					ingredients.append(ingredient)
					updateTasteValues(ingredient)

					print("Ingredient eingesammelt:", ingredient.id)
					#_audio_leave_item.play()
					print(ingredients)
					
					
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_audio_pick_up.play()
			_dragging = true
			_offset = global_position - get_global_mouse_position()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if _dragging:
				#_audio_leave_item.play()
				pass
			_dragging = false

func set_size(width: float, height: float) -> void:
	var tex_size = _sprite.texture.get_size()

	_sprite.scale = Vector2(
		width / tex_size.x,
		height / tex_size.y
	)
	
func updateTasteValues(ingredient) -> void:
	sweetness += ingredient.sweetness
	acidity += ingredient.acidity
	sourness += ingredient.sourness
	saltness += ingredient.saltness
	bitterness += ingredient.bitterness
	umami += ingredient.umami
	key_tasteness.append(ingredient.key_taste)
	



func _on_dish_container_area_area_entered(area: Area2D) -> void:
	if area.name == "Stove":
		print("Increasing Heat")
		_audio_sizzling.play()
		_heating = true
		


func _on_dish_container_area_area_exited(area: Area2D) -> void:
	if area.name == "Stove":
		print("Decreasing Heat")
		_audio_sizzling.stop()
		_heating = false
