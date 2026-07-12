extends Control
class_name SnowOverlay

var flakes: Array[Dictionary] = []
var storm_factor := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for index in range(100):
		flakes.append({
			"position": Vector2(randf_range(0.0, 1.0), randf_range(0.0, 1.0)),
			"speed": randf_range(14.0, 42.0),
			"drift": randf_range(-12.0, 16.0),
			"radius": randf_range(1.0, 2.8),
			"alpha": randf_range(0.35, 0.9),
			"streak": index % 5 == 0,
		})
	set_process(true)

func set_storm_intensity(factor: float) -> void:
	storm_factor = clampf(factor, 0.0, 1.0)

func _process(delta: float) -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		return
	var speed_mul := 1.0 + storm_factor * 2.2
	var drift_mul := 1.0 + storm_factor * 2.8
	for flake in flakes:
		var position: Vector2 = flake["position"]
		position.x += (flake["drift"] * drift_mul / maxf(size.x, 1.0)) * delta
		position.y += (flake["speed"] * speed_mul / maxf(size.y, 1.0)) * delta
		if position.y > 1.04:
			position.y = -0.04
			position.x = randf()
		if position.x < -0.05:
			position.x = 1.05
		elif position.x > 1.05:
			position.x = -0.05
		flake["position"] = position
	queue_redraw()

func _draw() -> void:
	if storm_factor > 0.15:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.55, 0.7, 0.85, 0.08 + storm_factor * 0.14))
	for flake in flakes:
		var position: Vector2 = flake["position"] * size
		var alpha: float = float(flake["alpha"]) * (1.0 + storm_factor * 0.35)
		var color := Color(0.88, 0.96, 1.0, minf(alpha, 1.0))
		if flake["streak"] or storm_factor > 0.4:
			var len_mul := 1.0 + storm_factor * 2.0
			draw_line(position, position + Vector2(7.0 * len_mul, 12.0 * len_mul), color, 1.0 + storm_factor)
		else:
			draw_circle(position, float(flake["radius"]) * (1.0 + storm_factor * 0.4), color)
