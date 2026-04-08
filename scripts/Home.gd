extends Control

@onready var list_container = $VBoxContainer/ScrollContainer/ListContainer

var lists = []

# ========================
# READY
# ========================
func _ready():
	print("READY WORKING")
	load_lists()
	#update_columns()
	

func _process(delta):
	DiscordRPC.state = ("Currently Has " + str(lists.size()+1) + " Lists")
	DiscordRPC.refresh()

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
	var panel = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(180, 100)

	# STYLE
	var style = StyleBoxFlat.new()
	style.bg_color = Color("3c3c3cff")
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	panel.add_theme_stylebox_override("panel", style)

	# CONTENT
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)

	var vbox = VBoxContainer.new()

	# TITLE
	var title = Label.new()
	title.text = list_data["name"]
	title.add_theme_font_size_override("font_size", 18)

	# SUBTEXT (placeholder for now)
	var subtitle = Label.new()
	subtitle.text = "0 tasks"
	subtitle.modulate = Color(0,0,0,0.6)

	# DELETE BUTTON (small)
	var delete_btn = Button.new()
	delete_btn.text = "×"
	delete_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	delete_btn.pressed.connect(func(): delete_list(list_data, panel))

	# CLICKABLE AREA
	var click_area = Button.new()
	click_area.text = ""
	click_area.flat = true
	click_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	click_area.pressed.connect(func(): open_list(list_data))

	# Layout
	vbox.add_child(delete_btn)
	vbox.add_child(title)
	vbox.add_child(subtitle)
	vbox.add_child(click_area)

	margin.add_child(vbox)
	panel.add_child(margin)

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
#func _notification(what):
	#if what == NOTIFICATION_RESIZED:
	#	update_columns()

#func update_columns():
#	list_container.columns = 3
