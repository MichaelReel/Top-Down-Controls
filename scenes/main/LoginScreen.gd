extends Control

onready var login_button = $Background/VBoxContainer/LoginButton
onready var username_input = $Background/VBoxContainer/Username
onready var password_input = $Background/VBoxContainer/Password

func _ready():
	# Connect to the connection signals
	Gateway.connect("login_reset", self, "_reset_login_button")
	Gateway.connect("login_complete", self, "_disconnect_and_close")

func _on_LoginButton_pressed():
	var username = username_input.get_text()
	var password = password_input.get_text()
	if username == "" or password == "":
		# Replace with some kind of GUI message:
		print("Please provide valid userID and password")
	else:
		login_button.disabled = true
		print("attempting to login")
		Gateway.connect_to_server(username, password)

func _reset_login_button():
	login_button.disabled = false
	
func _disconnect_and_close():
	Gateway.disconnect("login_reset", self, "_reset_login_button")
	Gateway.disconnect("login_complete", self, "_disconnect_and_close")
	self.queue_free()
