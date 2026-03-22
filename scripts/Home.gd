extends Control

@onready var list_container = $VBoxContainer/ScrollContainer/ListContainer

var lists = []

# ========================
# READY
# ========================
func _ready():
	print("READY WORKING")
	load_lists()
	update_columns()

# ========================
# BUTTON PRESS
# ========================
func _on_NewListButton_pressed():
	print("BUTTON CLICKED") # DEBUG
	
	var new_list = {
		"name": "New List " + str(lists.size() + 1)
	}
	
	lists.append(new_list)
	add_list_to_ui(new_list)
	save_lists()

# ========================
# ADD LIST TO GRID
# ========================
func add_list_to_ui(list_data):
	print("ADDING UI") # DEBUG
	
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(200, 120)
	
	var vbox = VBoxContainer.new()
	
	var button = Button.new()
	button.text = list_data["name"]
	button.pressed.connect(func(): open_list(list_data))
	
	var delete_btn = Button.new()
	delete_btn.text = "Delete"
	delete_btn.pressed.connect(func(): delete_list(list_data, panel))
	
	vbox.add_child(button)
	vbox.add_child(delete_btn)
	
	panel.add_child(vbox)
	
	list_container.add_child(panel)

# ========================
# DELETE LIST
# ========================
func delete_list(list_data, ui_node):
	lists.erase(list_data)
	ui_node.queue_free()
	save_lists()

# ========================
# OPEN LIST
# ========================
func open_list(list_data):
	print("OPENING LIST:", list_data["name"])
	var scene = load("res://scenes/list.tscn").instantiate()
	scene.list_data = list_data
	
	get_tree().root.add_child(scene)
	self.hide()

# ========================
# SAVE / LOAD
# ========================
func save_lists():
	var file = FileAccess.open("user://lists.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(lists))

func load_lists():
	if FileAccess.file_exists("user://lists.json"):
		var file = FileAccess.open("user://lists.json", FileAccess.READ)
		lists = JSON.parse_string(file.get_as_text())
		
		for list_data in lists:
			add_list_to_ui(list_data)

# ========================
# GRID
# ========================
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		update_columns()

func update_columns():
	var width = size.x
	
	if width < 600:
		list_container.columns = 1
	elif width < 1000:
		list_container.columns = 2
	else:
		list_container.columns = 3
