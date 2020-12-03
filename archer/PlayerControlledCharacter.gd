extends KinematicBody2D

export (PackedScene) var Arrow

const SPEED = 200
onready var sprite := $AnimatedSprite
onready var anim := $AnimatedSprite/AnimationPlayer

var bow_draw := false
var bow_taut := false
var bow_loosed := false

func _ready():
	anim.connect("animation_finished", self, "_anim_done")

func _physics_process(delta : float):
	var mouse = get_global_mouse_position();
	var dir := _get_input_dir() * SPEED
	var clicks = _get_input_clicks()
	
	move_and_slide(dir)
	sprite.look_at(mouse)
	
	# Rotate the sprite (but not the collision shape)
	if clicks["a"]:
		if bow_draw == false and bow_taut == false:
			bow_draw = true
			anim.play("draw")
	elif bow_draw:
		anim.play("look")
		bow_draw = false
	elif bow_taut:
		_fire_arrow()
		anim.play("loose")
		bow_taut = false
		bow_loosed = true

func _anim_done(anim_name : String):
	print("Animation done " + str(bow_draw) + ", " + str(bow_taut))
	if anim_name == "draw":
		bow_taut = true
		bow_draw = false
	elif anim_name == "loose":
		bow_loosed = false

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

func _fire_arrow():
	var arrow = Arrow.instance()
	owner.add_child(arrow)
	arrow.set_transform(sprite.global_transform)
