extends Node

var min_size = 512

func _process(_delta):
	var window = get_window()
	var size = window.size
	
	# If width and height are different, force them to match
	if size.x != size.y:
		# Use the larger dimension to fill space, 
		# or clamp to smaller to keep content visible
		var new_size = max(size.x, size.y)
		window.size = Vector2i(new_size, new_size)


func _on_new_list_button_pressed() -> void:
	print("button pressed")
	pass # Replace with function body.
