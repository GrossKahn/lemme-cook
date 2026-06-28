class_name Cuttinggame extends Node2D
## Brief class description
##
## Class description main body
##
## Footer, user for tags, for more information see https://git.lachanas.de/MECHAphant/cannonclabauter/wiki/Coding-Conventions
## @experimental example 

# --- Signals ---
# --- Constants ---

const CUT_LINE_POINT_MIN_DISTANCE : float = 40.0 #distance before new point is added (the smaller the more detailed is the visual line (not the cut line)
const CUT_LINE_STATIONARY_DELAY : float = 0.1 #after that amount of seconds remaining stationary will end the cut line process and cut the sources
const CUT_LINE_DIRECTION_THRESHOLD : float = -0.7 #smaller than treshold will end the cut line process and cut the sources (start_dir.dot(cur_dir) < threshold = endLine)

const CUT_LINE_MIN_LENGTH : float = 50.0 #the min length the cut line must have to be used for cutting (otherwise it will be discarded and no cutting occurs)
const CUT_LINE_EPSILON : float = 10.0 # used in func simplifyLineRDP // how detailed the actual cut line is (opposed to CUT_LINE_POINT_MIN_DISTANCE which determines how detailed the visual cut line is)
#const CUT_LINE_SEGMENT_MIN_LENGTH : float = 250.0 #used in my own simplifyLine func //how detailed the actual cut line is (opposed to CUT_LINE_POINT_MIN_DISTANCE which determines how detailed the visual cut line is)

# --- Enums --- (uppercase, no policy on visibility)
# --- Public Exports ---

@export var fracture_body_color: Color
@export var ingredient_scene: PackedScene

# --- Private Exports ---
#
# --- Public Onready ---
# (rarely makes sense, avoid)
# --- Private Onready ---
@onready var _cutboard = $CuttingBoard
# --- Public Attributes ---
# --- Private Attributes ---

var _input_disabled : bool = false

var _cur_fracture_color : Color = fracture_body_color


@onready var polyFracture := PolygonFracture.new()
@onready var _ingredient_parent := $IngredientParent
@onready var _rng := RandomNumberGenerator.new()
@onready var _cut_shape : PackedVector2Array = PolygonLib.createCirclePolygon(100.0, 1)
@onready var _cut_line := $CutLine
@onready var _pool_cut_visualizer := $Pool_CutVisualizer
@onready var _pool_fracture_shards := $Pool_FractureShards


var _cut_line_enabled : bool = false
var _cut_line_total_length : float = 0.0
var _cut_line_points : PackedVector2Array = []
var _cut_line_start_direction := Vector2.ZERO
var _cut_line_t : float = 0.0
var _cut_line_last_end_point := Vector3.ZERO #z is used as bool -> 0 = not a valid point/ 1 = valid point


		# (....,cut_min_area,fracture_min_area,shard_min_area,fracture_num)
#
var _cut_min_area = 500
var _fracture_min_area = 50
var _shard_min_area = 30
var _fracture_num = 3

# --- Public Methods ---
# --- Private Methods ---


func _input(event: InputEvent) -> void:
	if _input_disabled: return
	
	#this system works with 1 button (instead of 2 with right mouse button) -> makes it work on touch screens
	if event is InputEventMouseButton:
		if _cutboard.can_cut:

			if event.button_index == 1:
				if _cut_line_enabled:
					if event.is_released():
						if _cut_line.visible:
							endCutLine()
							_cut_line_enabled = false
							_cut_line.visible = false
							_cut_line_last_end_point = Vector3.ZERO
						else:
							#simpleCut(get_global_mouse_position())
							_cut_line_total_length = 0.0
							_cut_line_points = []
							_cut_line.clear_points()
							_cut_line_start_direction = Vector2.ZERO
							_cut_line_t = 0.0
							_cut_line_enabled = false
							_cut_line.visible = false
				else:
					if event.pressed:
						_cut_line_enabled = true

		else:
			_cut_line_total_length = 0.0
			_cut_line_points = []
			_cut_line.clear_points()
			_cut_line_start_direction = Vector2.ZERO
			_cut_line_t = 0.0
			_cut_line_enabled = false
			_cut_line.visible = false



func simpleCut(pos : Vector2) -> void:
	if _input_disabled: return
	
	var cut_pos : Vector2 = pos
	cutSourcePolygons(cut_pos, _cut_shape, 0.0, _rng.randf_range(250.0, 400.0), 2.0)
	_input_disabled = true
	set_deferred("_input_disabled", false)



func _calculateCutLine(cur_pos : Vector2, t : float) -> void:
	if _cut_line_points.size() <= 0:
		if _cut_line_last_end_point.z > 0.0:# last cut lines end point is new cut lines start point
			_cut_line_points.append(Vector2(_cut_line_last_end_point.x, _cut_line_last_end_point.y))
			_cut_line_last_end_point = Vector3.ZERO
		else:#there was no cut line before
			_cut_line_points.append(cur_pos)
	
	elif _cut_line_points.size() == 1 and not _cut_line.visible:
		var dis : float = (cur_pos - _cut_line_points[_cut_line_points.size() - 1]).length()
		if dis > CUT_LINE_MIN_LENGTH:
			_cut_line.visible = true
	else:
		var last_pos : Vector2 = lerp(_cut_line_points[_cut_line_points.size() - 1], cur_pos, t)
		var vec : Vector2 = cur_pos - last_pos
		var dir : Vector2 = vec.normalized()
		
		if _cut_line_start_direction == Vector2.ZERO:
			_cut_line_start_direction = dir
		elif dir == Vector2.ZERO:
			endCutLine()
			return
		else:
			if _cut_line_start_direction.dot(dir) < CUT_LINE_DIRECTION_THRESHOLD:
				endCutLine()
				return
		
		var last_point : Vector2 = _cut_line_points[_cut_line_points.size() - 1]
		var dis : float = (cur_pos - last_point).length()
		if dis > CUT_LINE_POINT_MIN_DISTANCE:
			_cut_line_points.append(cur_pos)
			_cut_line.points = _cut_line_points
			_cut_line_t = 0.0
			_cut_line_total_length += dis
		else:
			_cut_line.points = _cut_line_points
			_cut_line.add_point(cur_pos, -1)

func endCutLine() -> void:
	if _cut_line_points.size() > 1 and _cut_line_total_length > CUT_LINE_MIN_LENGTH and not _input_disabled:
		
#		var final_line : PoolVector2Array = PolygonLib.simplifyLine(_cut_line_points, CUT_LINE_SEGMENT_MIN_LENGTH)
		var final_line : PackedVector2Array = PolygonLib.simplifyLineRDP(_cut_line_points, CUT_LINE_EPSILON)
		var final_shape : PackedVector2Array = []
		
		final_shape = PolygonLib.offsetPolyline(final_line, 2.0, true)[0]
		final_shape = PolygonLib.translatePolygon(final_shape, -_cut_line_points[0])
		cutSourcePolygons(_cut_line_points[0], final_shape, 0.0, 0.0, 0.25)
	
	
	if _cut_line_points.size() > 1:
		var end_point : Vector2 = _cut_line_points[_cut_line_points.size() - 1]
		_cut_line_last_end_point = Vector3(end_point.x, end_point.y, 1.0)
	else:
		_cut_line_last_end_point = Vector3.ZERO
	
	_cut_line_total_length = 0.0
	_cut_line_points = []
	_cut_line.clear_points()
	_cut_line_start_direction = Vector2.ZERO
	_cut_line_t = 0.0
	
	_input_disabled = true
	set_deferred("_input_disabled", false)


func cutSourcePolygons(cut_pos : Vector2, cut_shape : PackedVector2Array, cut_rot : float, cut_force : float = 0.0, fade_speed : float = 2.0) -> void:
	var instance = _pool_cut_visualizer.getInstance()
	instance.spawn(cut_pos, fade_speed)
	instance.setPolygon(cut_shape)
	
	for source in _ingredient_parent.get_children():
		var source_polygon : PackedVector2Array = source.get_polygon()
		var total_area : float = PolygonLib.getPolygonArea(source_polygon)
		
		var source_trans : Transform2D = source.get_global_transform()
		var cut_trans := Transform2D(cut_rot, cut_pos)
		
		var s_lin_vel := Vector2.ZERO
		var s_ang_vel : float = 0.0
		var s_mass : float = 0.0
		
		if source is RigidBody2D:
			s_lin_vel = source.linear_velocity
			s_ang_vel = source.angular_velocity
			s_mass = source.mass
		
		
		# (....,cut_min_area,fracture_min_area,shard_min_area,fracture_num)
		#returns a dictionary containing shapes and fractures 
		#-> shapes is an array containing all shape infos generated -> the clipped shapes (the non overlapping areas of the source polygon and cut polygon) can be used for new source polygons
		#-> fractures is an array containing all fracture infos generated -> the intersected shapes (the overlapping areas of the source polygon and cut polygon) and the shapes smaller than cut_min_area are fractured
		#-> intersected shapes smaller than fracture_min_area are discarded
		#-> fracture pieces smaller than shard_min_area are discarded

		var cut_fracture_info : Dictionary = polyFracture.cutFracture(source_polygon, cut_shape, source_trans, cut_trans, _cut_min_area, _fracture_min_area, _shard_min_area, _fracture_num)
		
		if cut_fracture_info.shapes.size() <= 0 and cut_fracture_info.fractures.size() <= 0:
			continue
		
		for fracture in cut_fracture_info.fractures:
			for fracture_shard in fracture:
				var area_p : float = fracture_shard.area / total_area
				
				spawnFractureBody(fracture_shard, source.getTextureInfo(), s_mass * area_p)
		
		
		for shape in cut_fracture_info.shapes:
			var area_p : float = shape.area / total_area
			var mass : float = s_mass * area_p
			var dir : Vector2 = (shape.spawn_pos - cut_pos).normalized()
			
			call_deferred("spawnCutIngredient", shape, source.modulate, s_lin_vel + dir * cut_force, s_ang_vel, mass, cut_pos, source.getTextureInfo())
		
		source.queue_free()

func spawnFractureBody(fracture_shard : Dictionary, texture_info : Dictionary, new_mass : float) -> void:
	var instance = _pool_fracture_shards.getInstance()
	if not instance:
		return
	
	
	#fracture shard variant
	var dir : Vector2 = (fracture_shard.spawn_pos - fracture_shard.source_global_trans.get_origin()).normalized()
	instance.spawn(fracture_shard.spawn_pos, fracture_shard.spawn_rot, fracture_shard.source_global_trans.get_scale(), _rng.randf_range(0.5, 2.0))
	instance.setPolygon(fracture_shard.centered_shape, _cur_fracture_color, PolygonLib.setTextureOffset(texture_info, fracture_shard.centroid))
	instance.setMass(new_mass)
	instance.addForce(dir * 500.0)
	instance.addTorque(_rng.randf_range(-2, 2))


	#TODO: Anpassen zum spawnen von geschnittenen ingredient teilen
func spawnCutIngredient(shape_info : Dictionary, color : Color, lin_vel : Vector2, ang_vel : float, mass : float, cut_pos : Vector2, texture_info : Dictionary) -> void:
	var instance:Ingredient = ingredient_scene.instantiate()
	_ingredient_parent.add_child(instance)

	var texture=PolygonLib.setTextureOffset(texture_info, shape_info.centroid)
	var pos = shape_info.spawn_pos
	var rot = shape_info.spawn_rot
	var poly =shape_info.centered_shape

	instance.spawn_ingredient(texture.texture, poly,texture_info,pos,rot,color)

# --- Private Engine Methods---

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rng.randomize()
	
	var color := Color.WHITE
	color.s = fracture_body_color.s
	color.v = fracture_body_color.v
	color.h = _rng.randf()
	_cur_fracture_color = color
	#_ingredient_parent.modulate = _cur_fracture_color
	
	_cut_line.clear_points()
	_cut_line.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if _cut_line_enabled:
		var cur_pos : Vector2 = get_local_mouse_position()
		if _cut_line_t < 1.0:
			_cut_line_t += delta * (1.0 / CUT_LINE_STATIONARY_DELAY)
		_calculateCutLine(cur_pos, _cut_line_t)


# --- Debug Methods ---


# Gameplan cutting
# - Draw line 
#	- when mouse pressed, store point, released 2nd point
#	- use line to cut polygon
#		- spawn cut instance of ingredient
