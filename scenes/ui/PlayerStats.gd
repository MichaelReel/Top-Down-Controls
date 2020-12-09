extends Control

signal display_closing()

onready var strength = $NinePatchRect/VBoxContainer/Strength/StatValue
onready var vitality = $NinePatchRect/VBoxContainer/Vitality/StatValue
onready var dexterity = $NinePatchRect/VBoxContainer/Dexterity/StatValue
onready var intelligence = $NinePatchRect/VBoxContainer/Intelligence/StatValue
onready var wisdom = $NinePatchRect/VBoxContainer/Wisdom/StatValue

var wait_time : float

func _ready():
	Server.fetch_player_stats(self, "load_player_stats")
	wait_time = 0.10

func load_player_stats(stats):
	strength.set_text(str(stats.Strength))
	vitality.set_text(str(stats.Vitality))
	dexterity.set_text(str(stats.Dexterity))
	intelligence.set_text(str(stats.Intelligence))
	wisdom.set_text(str(stats.Wisdom))

func _process(delta):
	wait_time -= delta
	if wait_time > 0:
		return
	if Input.is_action_just_pressed("character"):
		emit_signal("display_closing")
		self.queue_free()
