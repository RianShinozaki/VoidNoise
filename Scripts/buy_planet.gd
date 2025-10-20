extends Button

@export var button_text: String
@export var base_cost: int = 2000
@export var cost_increase_factor: float = 2
@export var to_create: PackedScene
var current_cost
func _ready() -> void:
	pressed.connect(on_pressed)
	current_cost = base_cost
	text = button_text + str(current_cost)

func _process(_delta: float) -> void:
	disabled = Game.instance.noise < current_cost and not Game.instance.cheat_mode
	
func on_pressed() -> void:
	var _obj = to_create.instantiate()
	$"../../..".add_child(_obj)
	Game.noise -= current_cost
	current_cost *= cost_increase_factor
	current_cost = round(current_cost)
	text = button_text + str(current_cost)
