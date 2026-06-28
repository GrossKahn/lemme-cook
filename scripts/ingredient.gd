class_name Ingredient extends Polygon2D
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

@onready var _area: Area2D = $IngredientArea
# --- Public Attributes ---
var id: String
var key_taste: Array[String]

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
var _polygon2d: Polygon2D = self
# --- Public Methods ---

func spawn_ingredient(texture:Texture2D, poly:PackedVector2Array,texture_info : Dictionary,global_pos,global_rot,modulate) -> void:


	self.global_position = global_position
	self.global_rotation = global_rotation
	self.modulate = modulate

	self.set_polygon(poly)

	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.polygon = poly

	_area.add_child(collision_polygon)


	_area.add_child(collision_polygon)

	_polygon2d.texture = texture_info.texture
	_polygon2d.texture_scale = texture_info.scale
#	_polygon2d.texture_offset = texture_info.offset
	_polygon2d.texture_rotation = texture_info.rot
	



func getTextureInfo() -> Dictionary:
	return {"texture" : _polygon2d.texture, "rot" : _polygon2d.texture_rotation, "offset" : _polygon2d.texture_offset, "scale" : _polygon2d.texture_scale}
# --- Private Methods ---

func _create_polygon_from_image(texture:Texture2D):

	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture.get_image())
# Will cover the entire polygon
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size()))

	#var final_polygon = PackedVector2Array()
	#for p in polys:
	#	final_polygon =  Geometry2D.merge_polygons(final_polygon,p)[0]

	#return final_polygon
	return polys

func merge_all_polygons(polygons: Array[PackedVector2Array]) -> PackedVector2Array:
	if polygons.is_empty():
		return PackedVector2Array()

	if polygons.size() == 1:
		return polygons[0]

	var final_polygon: PackedVector2Array = polygons[0]
	for i in range(1, polygons.size()):
		var result: Array[PackedVector2Array] = Geometry2D.merge_polygons(final_polygon, polygons[i])

		# is_polygon_clockwise() returns false for outer boundaries, true for holes
		for poly in result:
			if not Geometry2D.is_polygon_clockwise(poly):
				# This is an outer boundary — pick the largest one
				#var area := _polygon_area(poly)
				#if area > best_area:
				#	best_area = area
				#	best = poly
				final_polygon = poly

	return final_polygon 



# --- Private Engine Methods---


func setup(ingredient_id: String, texture: Texture2D, width: float, height: float) -> void:
	id = ingredient_id
#	_sprite = Sprite2D.new()
#	_sprite.texture = texture
#	
#	
#	add_child(_sprite)
#	set_size(width, height)

	var new_polygon = merge_all_polygons(_create_polygon_from_image(texture))

	self.set_polygon(new_polygon)
	self.texture = texture
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.polygon = new_polygon

	_area.add_child(collision_polygon)

	
	
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
	
func set_key_taste(value: String) -> void:
	key_taste.append(value)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#setup("tomato",load("res://tomato.png"),0,0)
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
	
