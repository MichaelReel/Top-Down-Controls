extends Control

signal login_completed

onready var login_button = $Background/VBoxContainer/LoginButton
onready var username_input = $Background/VBoxContainer/Username
onready var password_input = $Background/VBoxContainer/Password
onready var error_output = $ErrorMsg

func _ready():
	# Connect to the connection signals
	var _ignore = Gateway.connect("login_reset", self, "_reset_login_button")
	_ignore = Gateway.connect("login_failed", self, "_show_error_message")
	_ignore = Server.connect("login_complete", self, "_disconnect_and_close")
	_ignore = Server.connect("login_failed", self, "_show_error_message")

func _on_LoginButton_pressed():
	var username = username_input.get_text()
	var password = password_input.get_text()
	if username == "" or password == "":
		# Replace with some kind of GUI message:
		error_output.set_text("Please provide valid userID and password")
	else:
		login_button.disabled = true
		print("attempting to login")
		Gateway.connect_to_server(username, password)

func _reset_login_button():
	login_button.disabled = false
	
func _disconnect_and_close():
	Gateway.disconnect("login_reset", self, "_reset_login_button")
	Gateway.disconnect("login_failed", self, "_show_error_message")
	Server.disconnect("login_complete", self, "_disconnect_and_close")
	Server.disconnect("login_failed", self, "_show_error_message")
	emit_signal("login_completed")
	self.queue_free()

func _show_error_message(message: String):
	error_output.set_text(message)
