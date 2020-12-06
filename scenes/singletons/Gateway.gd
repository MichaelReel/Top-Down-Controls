extends Node

signal login_reset()
signal login_complete()

var network : NetworkedMultiplayerENet
var gateway_api : MultiplayerAPI
var ip = "localhost"
var port = 1981

var username : String
var password : String

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func connect_to_server(_username : String, _password : String):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	print("Attempting to create connection to gateway server")
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")

func _on_connection_failed():
	print("Failed to connect to gateway server")
	# re-enable login button
	emit_signal("login_reset")

func _on_connection_succeeded():
	print("Successfully connected to gateway server")
	request_login()

func request_login():
	rpc_id(1, "login_request", username, password)
	username = ""
	password = ""

remote func return_login_request(results):
	print("login results received")
	if results == true:
		Server.connect_to_server()
		# queue free the login screen
		emit_signal("login_reset")
	else:
		print("Authentication failed. Please provide correct username and password")
		# re-enable login button
	emit_signal("login_complete")
	
	network.disconnect("connection_failed", self, "_on_connection_failed")
	network.disconnect("connection_succeeded", self, "_on_connection_succeeded")
		
