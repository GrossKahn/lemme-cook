class_name SoundControl extends HSlider

@export var sound_bus_name: String

var sound_bus_id

func _ready():
	sound_bus_id = AudioServer.get_bus_index(sound_bus_name)
	
	
func _on_value_changed(value: float) -> void:
		var db = linear_to_db(value)
		AudioServer.set_bus_volume_db(sound_bus_id, db)
