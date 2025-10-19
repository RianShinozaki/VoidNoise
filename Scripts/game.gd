@tool
class_name Game

extends Node2D

@export var current_space_size: Vector2
static var instance: Game
const screen_size = Vector2(1152, 648)

func _ready() -> void:
	instance = self
	
func _process(_delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	draw_set_transform_matrix(global_transform.affine_inverse())
	var _rect = Rect2()
	_rect.size = Vector2( (current_space_size.x - screen_size.x) /2, screen_size.y)
	_rect.position = Vector2( screen_size.x/2, -screen_size.y/2)
	draw_rect(_rect, Color.BLACK, true)
	
	_rect.size = Vector2( (current_space_size.x - screen_size.x) /2, screen_size.y)
	_rect.position = Vector2( -current_space_size.x/2, -screen_size.y/2)
	draw_rect(_rect, Color.BLACK, true)
	
	_rect.size = Vector2( screen_size.x, (current_space_size.y - screen_size.y) /2)
	_rect.position = Vector2( -screen_size.x/2, screen_size.y/2)
	draw_rect(_rect, Color.BLACK, true)
	
	_rect.size = Vector2( screen_size.x, (current_space_size.y - screen_size.y) /2)
	_rect.position = Vector2( -screen_size.x/2, -current_space_size.y/2)
	draw_rect(_rect, Color.BLACK, true)
	
	
