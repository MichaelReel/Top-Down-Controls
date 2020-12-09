extends Node

var one_room_test = preload("res://scenes/main/OneRoomTest.tscn")
var login_screen = preload("res://scenes/ui/LoginScreen.tscn")

func _ready():
	# Ensure networking stays running
	Gateway.pause_mode = Node.PAUSE_MODE_PROCESS
	Server.pause_mode = Node.PAUSE_MODE_PROCESS
	
	# Add client display behind
	var test_room = one_room_test.instance()
	add_child(test_room)
	
	# Create the login dialog and put it up front
	get_tree().paused = true
	var login = login_screen.instance()
	login.pause_mode = Node.PAUSE_MODE_PROCESS
	login.connect("login_completed", self, "_unpause")
	add_child(login)

func _unpause():
	get_tree().paused = false

func show_ui_and_pause(ui_node : Node):
	get_tree().paused = true
	ui_node.pause_mode = Node.PAUSE_MODE_PROCESS
	var _ignore = ui_node.connect("display_closing", self, "_unpause")
	add_child(ui_node)
	
