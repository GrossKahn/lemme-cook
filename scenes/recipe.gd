class_name Recipe

var ingredients: Array[String]
var key_taste: Array[String]

var sweetness = 0.0
var acidity = 0.0
var sourness = 0.0
var saltness = 0.0
var bitterness = 0.0
var umami = 0.0

func _init() -> void:
	pass

func set_recipe(recipe) -> void:
	sweetness = recipe["sweetness"]
	acidity = recipe["acidity"]
	sourness = recipe["sourness"]
	bitterness = recipe["bitterness"]
	umami = recipe["umami"]
	saltness = recipe["saltiness"]
	var key_taste_raw = recipe["key_taste"]
	for t in key_taste_raw:
		key_taste.append(str(t))
		
	var ingredients_raw = recipe["ingredients"]

	for t in ingredients_raw:
		ingredients.append(t)
		
	
