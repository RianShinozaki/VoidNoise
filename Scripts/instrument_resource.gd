class_name InstrumentResource

extends Resource

@export var audio: AudioStream
@export var melody: Array[NoteResource]
var melody_index: int = 0
var volume_curve_t: float = 1
@export var volume_curve: Curve
@export var volume_curve_delta: float
@export var octave_steps: int
var current_octave_step = 0
