extends Node

var one_room_test = preload("res://scenes/main/OneRoomTest.tscn")
var login_screen = preload("res://scenes/main/LoginScreen.tscn")

func _ready():
	# Disable everything (except login) until login complete
	Gateway.pause_mode = Node.PAUSE_MODE_PROCESS
	Server.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	
	# Add client display behind
	var test_room = one_room_test.instance()
	add_child(test_room)
	
	# Create the login dialog and put it up front
	var login = login_screen.instance()
	login.pause_mode = Node.PAUSE_MODE_PROCESS
	login.connect("login_completed", self, "_unpause")
	add_child(login)

func _unpause():
	get_tree().paused = false
