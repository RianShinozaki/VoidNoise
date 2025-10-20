extends Area2D

@export var radius: float
@export var point_value: int
@export var gradient: Texture2D
@export var audio_name: String

var place_mode: bool = true
var can_place: bool = true
var area_collision_list: Array[Area2D]

func _ready() -> void:
	$CollisionShape2D.shape.radius = radius
	$CancelPlacementArea/CollisionShape2D.shape.radius = radius+24
	
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	place_mode = true
	modulate.a = 0.4
	
func _process(_delta: float) -> void:
	if place_mode:
		position = get_global_mouse_position()
	
	can_place = true
	var _screen = Game.instance.current_space_size

	if position.x > _screen.x/2 - radius:
		can_place = false
	if position.x < -_screen.x/2 + radius:
		can_place = false
	if position.y > _screen.y/2 - radius:
		can_place = false
	if position.y < -_screen.y/2 + radius:
		can_place = false
	
	self_modulate = Color.WHITE
	if not can_place or not area_collision_list.is_empty():
		self_modulate = Color.RED
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and place_mode:
			queue_free()
			return
		if not area_collision_list.is_empty() or not can_place: return
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and place_mode:
			place_mode = false
			collision_layer = 1
			collision_mask = 1
			modulate.a = 1
			get_viewport().set_input_as_handled()
		
			
func on_area_entered(_area: Area2D):
	if place_mode:
		if not _area in area_collision_list and _area != $CancelPlacementArea:
			area_collision_list.append(_area)
		return
	SFXManager.queue_audio(audio_name, position)
	Game.noise += point_value

func on_area_exited(_area: Area2D):
	if _area in area_collision_list:
		area_collision_list.erase(_area)
func _draw() -> void:
	draw_set_transform_matrix(global_transform.affine_inverse())
	draw_circle(position, radius, Color.WHITE, true)
	@warning_ignore("integer_division")
	draw_texture(gradient, position - Vector2(gradient.get_width()/2, gradient.get_height()/2))
