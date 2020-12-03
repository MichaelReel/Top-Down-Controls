extends Area2D

const SPEED = 400
const LIFE_TIME = 3.0
var life := LIFE_TIME

func _physics_process(delta):
	position += transform.x * SPEED * delta
	
	life -= delta
	if life < 0.0:
		self.queue_free()
