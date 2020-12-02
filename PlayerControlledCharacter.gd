extends KinematicBody2D

const SPEED = 200
onready var sprite := $Sprite

func _physics_process(delta : float):
	var mouse = get_global_mouse_position();
	var dir := _get_input_dir() * SPEED
	var clicks = _get_input_clicks()
	
	move_and_slide(dir)
	
	# Rotate the sprite (but not the collision shape)
	if clicks["a"]:
		sprite.look_at(mouse)
	else:
		sprite.look_at(position + dir)

func _get_input_dir() -> Vector2:
	var dir := Vector2()
	dir.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	dir.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
	return dir

func _get_input_clicks() -> Dictionary:
	return {
		"a" : Input.is_action_pressed("click_a"),
		"b" : Input.is_action_pressed("click_b"),
	}