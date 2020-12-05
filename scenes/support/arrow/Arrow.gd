extends Area2D

const LIFE_TIME = 3.0

var life := LIFE_TIME
var speed := 0.0
var damage := 0.0

export (bool) var flying := false

func _ready():
	Server.fetch_skill_data("arrow/speed", self, "_set_speed")
	Server.fetch_skill_data("arrow/damage", self, "_set_damage")

func _set_damage(s_damage):
	damage = s_damage

func _set_speed(s_speed):
	speed = s_speed

func _physics_process(delta):
	if flying:
		position += transform.x * speed * delta
		life -= delta
		if life < 0.0:
			self.queue_free()
