class_name SFXManager

extends Node2D

const channels: int = 32

enum Note{
	C = 0,
	C_sharp = 1,
	D = 2,
	D_sharp = 3,
	E = 4,
	F = 5,
	F_sharp = 6,
	G = 7,
	G_sharp = 8,
	A = 9,
	A_sharp = 10,
	B = 11
}
	
static var instance: SFXManager

var available_channels: Array[AudioStreamPlayer2D]
var unavailable_channels: Array[AudioStreamPlayer2D]
var queued_audio: Array[QueuedAudio]
var chord_shift_index = 0
var chord_shift_time = 0
var chord_shift_max_time = 4
@export var chord_shift: Array[int]

@export var instruments_dictionary: Dictionary[String, InstrumentResource]

signal audio_initiated

func _ready() -> void:
	instance = self
	for i in range(channels):
		var _audio = AudioStreamPlayer2D.new()
		add_child(_audio)
		available_channels.append(_audio)

func _process(_delta: float) -> void:
	chord_shift_time += _delta
	if chord_shift_time > chord_shift_max_time:
		chord_shift_index += 1
		chord_shift_time = 0
		if chord_shift_index == chord_shift.size():
			chord_shift_index = 0
	for key in instruments_dictionary:
		if instruments_dictionary[key].volume_curve_t < 1:
			instruments_dictionary[key].volume_curve_t = move_toward(instruments_dictionary[key].volume_curve_t, 1, _delta * instruments_dictionary[key].volume_curve_delta)
	play_all_queued_audio()

func queue_audio_instance(_audio: String, _position: Vector2):
	var _a = QueuedAudio.new()
	_a.instrument = instruments_dictionary[_audio]
	_a.position = _position
	queued_audio.append(_a)
	
static func queue_audio(_audio: String, _position: Vector2):
	instance.queue_audio_instance(_audio, _position)

func play_all_queued_audio():
	if queued_audio.is_empty(): return
	for _a in queued_audio:
		play_sound_at_instance(_a.instrument, _a.position)
	#print("all done")
	queued_audio.clear()

func play_sound_at_instance(_instrument: InstrumentResource, _position: Vector2) -> AudioStreamPlayer2D:
	var _vol: float = _instrument.volume_curve.sample(_instrument.volume_curve_t)*-80
	if _vol < -20:
		return
	
	if available_channels.is_empty(): 
		var _sfx_to_free = unavailable_channels[0]
		for dict in _sfx_to_free.finished.get_connections():
			_sfx_to_free.finished.disconnect(dict.callable)
		unavailable_channels.erase(_sfx_to_free)
		available_channels.append(_sfx_to_free)
	var _sfx = available_channels[0]
	available_channels.remove_at(0)
	_sfx.stream = _instrument.audio
	_sfx.position = _position
	var _current_note = _instrument.melody[_instrument.melody_index]
	var _step = chord_shift[chord_shift_index] + float(_current_note.note + (12 * (_current_note.octave-3 + _instrument.current_octave_step)))
	_sfx.pitch_scale = pow(2, _step/12)
	
	if _instrument.volume_curve_t >= 1:
		_instrument.volume_curve_t = 0
	_sfx.volume_db = _vol
	#print(_vol)
	
	unavailable_channels.append(_sfx)
	var return_on_finished = func():
		unavailable_channels.erase(_sfx)
		available_channels.append(_sfx)
		for dict in _sfx.finished.get_connections():
			_sfx.finished.disconnect(dict.callable)
	_sfx.finished.connect(return_on_finished)
	_sfx.play()
	
	_instrument.melody_index += 1
	if _instrument.melody_index >= _instrument.melody.size(): 
		_instrument.melody_index = 0
		_instrument.current_octave_step += 1
		if _instrument.current_octave_step > _instrument.octave_steps:
			_instrument.current_octave_step = 0
	emit_signal("audio_initiated")
	return _sfx
