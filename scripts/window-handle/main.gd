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

func _ready():
	# Application ID
	DiscordRPC.app_id = 1491448991135567953
	# this is boolean if everything worked
	print("Discord working: " + str(DiscordRPC.get_is_discord_working()))
	# Set the first custom text row of the activity here
	DiscordRPC.details = "Godlink Reminders"
	# Set the second custom text row of the activity here
	DiscordRPC.state = "Loading..."
	# Image key for large image from "Art Assets" from the Discord Developer website
	DiscordRPC.large_image = "icon"
	# Tooltip text for the large image
	DiscordRPC.large_image_text = "Try it now!"
	# Image key for small image from "Art Assets" from the Discord Developer website
	#DiscordRPC.small_image = "icon"
	# Tooltip text for the small image
	#DiscordRPC.small_image_text = "Fighting the end boss! D:"
	# "02:41 elapsed" timestamp for the activity
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	# "59:59 remaining" timestamp for the activity
	#DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600
	# Always refresh after changing the values!
	DiscordRPC.refresh()

func _on_new_list_button_pressed() -> void:
	print("button pressed")
	pass # Replace with function body.
