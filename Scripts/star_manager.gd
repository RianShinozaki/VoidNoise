class_name StarManager

extends Node2D

@export var speed: float
const radius: float = 1

@export var stars: Array[Star]
@export var star_gradient: Texture2D
@export var comet_gradient: Texture2D
@onready var comet_object = preload("res://Objects/comet.tscn")
@onready var star_object = preload("res://Objects/star.tscn")
static var instance: StarManager

var current_place

func _ready() -> void:
	instance = self
	current_place = comet_object

func _physics_process(_delta: float) -> void:
	queue_redraw()
	if Engine.is_editor_hint(): return
	
	var _screen = Game.instance.current_space_size
	
	for _star in stars:
		var _pos = _star.position
		var _dir = _star.direction 
		if _pos.x > _screen.x/2 - radius:
			_dir = _star.bounce(_dir, Vector2.LEFT)
		if _pos.x < -_screen.x/2 + radius:
			_dir = _star.bounce(_dir, Vector2.RIGHT)
		if _pos.y > _screen.y/2 - radius:
			_dir = _star.bounce(_dir, Vector2.UP)
		if _pos.y < -_screen.y/2 + radius:
			_dir = _star.bounce(_dir, Vector2.DOWN)
		
		_pos = _star.position
		_pos += Vector2.from_angle(_dir) * speed * _delta
		_star.position = _pos
		_star.direction = _dir

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var _star = current_place.instantiate()
			stars.append(_star)
			add_child(_star)
			_star.position = Vector2.ZERO
			if current_place != comet_object:
				current_place = comet_object
				$"../Control/HBoxContainer".visible = true
	
func _draw() -> void:
	draw_set_transform_matrix(global_transform.affine_inverse())
	for _star in stars:
		if _star is Comet:
			draw_circle(_star.position, radius, Color.AQUA, true)
			@warning_ignore("integer_division")
			draw_texture(comet_gradient, _star.position - Vector2(comet_gradient.get_width()/2, comet_gradient.get_height()/2))
		else:
			draw_circle(_star.position, radius, Color.WHITE, true)
			@warning_ignore("integer_division")
			draw_texture(star_gradient, _star.position - Vector2(star_gradient.get_width()/2, star_gradient.get_height()/2))
		
func buy_star():
	var _star = star_object.instantiate()
	stars.append(_star)
	add_child(_star)
	_star.position = Vector2.ZERO
