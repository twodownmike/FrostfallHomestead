extends Control
class_name SnowOverlay

var flakes: Array[Dictionary] = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for index in range(80):
		flakes.append({
			"position": Vector2(randf_range(0.0, 1.0), randf_range(0.0, 1.0)),
			"speed": randf_range(12.0, 38.0),
			"drift": randf_range(-10.0, 14.0),
			"radius": randf_range(1.0, 2.8),
			"alpha": randf_range(0.35, 0.85),
		})
	set_process(true)

func _process(delta: float) -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		return

	for flake in flakes:
		var position: Vector2 = flake["position"]
		position.x += (flake["drift"] / maxf(size.x, 1.0)) * delta
		position.y += (flake["speed"] / maxf(size.y, 1.0)) * delta
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
	for flake in flakes:
		var position: Vector2 = flake["position"] * size
		var color := Color(0.88, 0.96, 1.0, flake["alpha"])
		draw_circle(position, flake["radius"], color)
