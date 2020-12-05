extends Node

var one_room_test = preload("res://scenes/main/OneRoomTest.tscn")

func _ready():
	var test_room = one_room_test.instance()
	add_child(test_room)
