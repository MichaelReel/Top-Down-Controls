extends KinematicBody2D

export (PackedScene) var Arrow
export (PackedScene) var StatsScreen

const SPEED = 200
onready var sprite := $AnimatedSprite
onready var anim := $AnimatedSprite/AnimationPlayer
onready var ammo_slot := $AnimatedSprite/Ammo

var bow_draw := false
var bow_taut := false
var bow_loosed := false

func _ready():
	var _ignore = anim.connect("animation_finished", self, "_anim_done")
	
func _physics_process(_delta : float):
	var mouse = get_global_mouse_position();
	var dir := _get_input_dir() * SPEED
	var clicks = _get_input_clicks()
	
	if Input.is_action_just_pressed("character"):
		_show_stats()
	
	var _ignore = move_and_slide(dir)
	sprite.look_at(mouse)
	
	# Rotate the sprite (but not the collision shape)
	if clicks["a"]:
		if bow_draw == false and bow_taut == false:
			_load_arrow()
			anim.play("draw")
			bow_draw = true
	elif bow_draw:
		_drop_arrow()
		anim.play("look")
		bow_draw = false
	elif bow_taut:
		_fire_arrow()
		anim.play("loose")
		bow_taut = false
		bow_loosed = true

func _anim_done(anim_name : String):
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

func _load_arrow():
	var arrow = Arrow.instance()
#	arrow.set_enabled(false)
	ammo_slot.add_child(arrow)

func _drop_arrow():
	var arrow := ammo_slot.get_child(0)
	ammo_slot.remove_child(arrow)
	arrow.queue_free()

func _fire_arrow():
	var arrow := ammo_slot.get_child(0)
	var arrow_transform = arrow.global_transform
	ammo_slot.remove_child(arrow)
	owner.add_child(arrow)
	arrow.set_transform(arrow_transform)
	arrow.flying = true

func _show_stats():
	var stats_screen : Node = StatsScreen.instance()
	get_tree().get_root().get_node("SceneHandler").show_ui_and_pause(stats_screen)
	
