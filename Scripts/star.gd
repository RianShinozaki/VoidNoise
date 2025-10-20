class_name Star

extends Area2D

@export var direction: float

func _ready() -> void:
	direction = randf_range(0, 2*PI)
	$CollisionShape2D.shape.radius = StarManager.radius
	area_entered.connect(on_area_entered)
	
func on_area_entered(area: Area2D):
	direction = bounce(direction, (area.position - position).normalized(), area)

func bounce(_angle: float, _n: Vector2, _area: Area2D = null) -> float:
	if(_area is Comet or _area is Star or _area == null):
		SFXManager.queue_audio("star", position)
	var _vec = Vector2.from_angle(_angle)
	_vec = _vec.bounce(_n)
	position += _n
	Game.noise += 10
	return _vec.angle()
