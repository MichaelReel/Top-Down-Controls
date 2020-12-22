extends Node

signal login_complete()
signal login_failed(message)

var network := NetworkedMultiplayerENet.new()
var ip := "localhost"
var port := 1980

var token : String
var connected := false
var request_queue := { "skill" : {}, "stats" : {}}

func connect_to_server(token):
	self.token = token
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

# Token request and return
remote func fetch_token():
	rpc_id(1, "return_token", token)

remote func return_token_verification_results(result):
	if result == true:
		emit_signal("login_complete")
	else:
		emit_signal("login_failed", "Authentication failed. Token verification was unsuccessful.")

# Some generic functions for queuing the responding to fetches
func setup_return_path(queue_name: String, key: String, target: Object, method: String):
	request_queue[queue_name][key] = {"target" : target, "method" : method}

func forward_return_data(queue_name: String, key: String, s_value):
	var target : Object = request_queue[queue_name][key]["target"]
	var method : String = request_queue[queue_name][key]["method"]
	target.call(method, s_value)
	var _ignore = request_queue[queue_name].erase(key)

# Request and process skill data
func fetch_skill_data(key_path : String, target : Object, ret_func : String):
	var key = str(target.get_instance_id()) + ":" + key_path
	setup_return_path("skill", key, target, ret_func)
	rpc_id(1, "fetch_skill_data", key_path, key)

remote func return_skill_data(s_value, key : String):
	forward_return_data("skill", key, s_value)

# Request and process stats data
func fetch_player_stats(target : Object, ret_func : String):
	var key : String = str(target.get_instance_id())
	setup_return_path("stats", key, target, ret_func)
	rpc_id(1, "fetch_player_stats", key)

remote func return_player_stats(s_value, key : String):
	forward_return_data("stats", key, s_value)


