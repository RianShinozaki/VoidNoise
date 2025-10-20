@tool
class_name Game

extends Node2D

@export var cheat_mode: bool
@export var current_space_size: Vector2
static var instance: Game
static var noise: int = 0
const screen_size = Vector2(1152, 648)
var score_hidden: bool = true
var space_level: int = 0

func _ready() -> void:
	expand_space()
	instance = self
	$NoiseScore.modulate.a = 0
	$Control.modulate.a = 0
	if cheat_mode:
		ultra_expand_space()
		score_hidden = false
		get_tree().create_tween().tween_property($NoiseScore, "modulate", Color(1, 1, 1, 1), 1.0)
		get_tree().create_tween().tween_property($Control, "modulate", Color(1, 1, 1, 1), 1.0)
	
func _process(_delta: float) -> void:
	queue_redraw()
	if not Engine.is_editor_hint():
		$NoiseScore.text = str(noise)
		if score_hidden and noise > 10:
			score_hidden = false
			get_tree().create_tween().tween_property($NoiseScore, "modulate", Color(1, 1, 1, 1), 1.0)
			get_tree().create_tween().tween_property($Control, "modulate", Color(1, 1, 1, 1), 1.0)
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
	
func expand_space():
	var new_size = current_space_size + Vector2.ONE * 64
	new_size.x = min(new_size.x, screen_size.x)
	new_size.y = min(new_size.y, screen_size.y)
	await get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(self, "current_space_size", new_size, 1).finished
	space_level += 1
	$Control/HBoxContainer.get_child(space_level).visible = true
	
func ultra_expand_space():
	var new_size = current_space_size + Vector2.ONE * 64 * 6
	new_size.x = min(new_size.x, screen_size.x)
	new_size.y = min(new_size.y, screen_size.y)
	await get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(self, "current_space_size", new_size, 1).finished
	for _child in $Control/HBoxContainer.get_children():
		_child.visible = true
