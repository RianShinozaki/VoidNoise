class_name Star

extends Resource

@export var direction: float
@export var position: Vector2

func init():
	direction = randf_range(0, 2*PI)
