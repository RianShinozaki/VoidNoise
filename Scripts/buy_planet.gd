extends Button

@export var button_text: String
@export var base_cost: int = 2000
@export var cost_increase_factor: float = 2
@export var to_create: PackedScene
@export var description: String

var current_cost
func _ready() -> void:
	pressed.connect(on_pressed)
	current_cost = base_cost
	text = button_text + str(current_cost)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func _process(_delta: float) -> void:
	disabled = Game.instance.noise < current_cost and not Game.instance.cheat_mode
	
func on_pressed() -> void:
	var _obj = to_create.instantiate()
	$"../../..".add_child(_obj)
	_obj.placed.connect(on_placed)
	_obj.canceled.connect(on_canceled)
	$"..".visible = false
	$"../../ExpandSpaceButton".visible = false
	$"../../Description".visible = true
	$"../../PlanetInstructions".visible = true
	$"../../PlanetInstructions".text = "drag and drop to place " + button_text
	
func on_placed() -> void:
	Game.noise -= current_cost
	current_cost *= cost_increase_factor
	current_cost = roundi(current_cost)
	text = button_text + str(current_cost)
	$"..".visible = true
	$"../../ExpandSpaceButton".visible = true
	$"../../Description".visible = false
	$"../../PlanetInstructions".visible = false
	
func on_canceled() -> void:
	$"..".visible = true
	$"../../ExpandSpaceButton".visible = true
	$"../../Description".visible = false
	$"../../PlanetInstructions".visible = false

func on_mouse_entered() -> void:
	$"../../Description".text = description
	$"../../Description".visible = true

func on_mouse_exited() -> void:
	$"../../Description".visible = false
