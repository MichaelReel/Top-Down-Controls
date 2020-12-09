extends Node

var network := NetworkedMultiplayerENet.new()
var ip := "localhost"
var port := 1980

var connected := false
var request_queue := {}

func connect_to_server():
	var _ignore = network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	print("Loading networking: " + str(network))
	
	_ignore = network.connect("connection_failed", self, "_on_connection_failed")
	_ignore = network.connect("connection_succeeded", self, "_on_connection_succeeded")
	_ignore = network.connect("server_disconnected", self, "_on_server_disconnected")

func _on_connection_failed():
	print("Failed to connect")

func _on_connection_succeeded():
	print("Successfully connected")
	connected = true

func _on_server_disconnected():
	print("Server disconnected")
	connected = false

func fetch_skill_data(key_path : String, target: Object, ret_func : String):
	if not connected:
		return
	var inst_id : String = str(target.get_instance_id()) + ":" + key_path
	print("requesting " + str(inst_id))
	request_queue[inst_id] = {"target" : target, "method" : ret_func}
	rpc_id(1, "fetch_skill_data", key_path, inst_id)

remote func return_skill_data(s_value, inst_id : String):
	var target : Object = request_queue[inst_id]["target"]
	var method : String = request_queue[inst_id]["method"]
	target.call(method, s_value)
	var _ignore = request_queue.erase(inst_id)
