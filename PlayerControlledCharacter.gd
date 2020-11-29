extends KinematicBody2D

const SPEED = 100

func _physics_process(delta : float):
	var dir := get_input_dir()
	dir *= SPEED
	
	move_and_slide(dir)

func get_input_dir() -> Vector2:
	var dir := Vector2()
	dir.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	dir.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
	return dir
