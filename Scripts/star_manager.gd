class_name StarManager

extends Node2D

@export var speed: float
const radius: float = 8

@export var stars: Array[Star]

func _physics_process(_delta: float) -> void:
	queue_redraw()
	if Engine.is_editor_hint(): return
	
	var _screen = Game.instance.current_space_size
	
	for _star in stars:
		var _pos = _star.position
		var _dir = _star.direction 
		if _pos.x > _screen.x/2 - radius:
			_dir = bounce(_dir, Vector2.LEFT)
		if _pos.x < -_screen.x/2 + radius:
			_dir = bounce(_dir, Vector2.RIGHT)
		if _pos.y > _screen.y/2 - radius:
			_dir = bounce(_dir, Vector2.UP)
		if _pos.y < -_screen.y/2 + radius:
			_dir = bounce(_dir, Vector2.DOWN)
			
		_pos += Vector2.from_angle(_dir) * speed * _delta
		_star.position = _pos
		_star.direction = _dir

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var _star = Star.new()
			_star.init()
			stars.append(_star)
		
func bounce(_angle: float, _n: Vector2) -> float:
	var _vec = Vector2.from_angle(_angle)
	_vec = _vec.bounce(_n)
	return _vec.angle()
	
func _draw() -> void:
	draw_set_transform_matrix(global_transform.affine_inverse())
	for _star in stars:
		draw_circle(_star.position, radius, Color.WHITE, true)
