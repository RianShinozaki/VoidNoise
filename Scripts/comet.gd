class_name Comet

extends Star

var life_time: float = 0
@export var max_life_time: float = 5

func _process(_delta: float) -> void:
	life_time += _delta
	if(life_time >= max_life_time): 
		StarManager.instance.stars.erase(self)
		queue_free()

func bounce(_angle: float, _n: Vector2, _area: Area2D = null) -> float:
	if(_area is Comet or _area == null):
		SFXManager.queue_audio("comet", position)
	var _vec = Vector2.from_angle(_angle)
	_vec = _vec.bounce(_n)
	position += _n
	Game.noise += 1
	return _vec.angle()
