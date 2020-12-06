extends Node

var one_room_test = preload("res://scenes/main/OneRoomTest.tscn")
var login_screen = preload("res://scenes/main/LoginScreen.tscn")

func _ready():
	var test_room = one_room_test.instance()
	add_child(test_room)
	var login = login_screen.instance()
	add_child(login)
