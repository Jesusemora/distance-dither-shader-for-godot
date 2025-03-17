extends Node

#TAA DITHER
var _time_step : float = 0.0
func _process(delta: float) -> void:
	if _time_step < 4.0:
		_time_step += 1
	else:
		_time_step = 1
	RenderingServer.global_shader_parameter_set("_time_step", _time_step)
