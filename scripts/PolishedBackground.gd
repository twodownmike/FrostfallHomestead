extends Control
class_name PolishedBackground

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
	var top := Color("#071728")
	var middle := Color("#173b54")
	var bottom := Color("#d9eef3")
	draw_rect(Rect2(Vector2.ZERO, size), bottom)
	for index in range(22):
		var t := float(index) / 21.0
		var color := top.lerp(middle, minf(t * 1.5, 1.0)) if t < 0.66 else middle.lerp(bottom, (t - 0.66) / 0.34)
		draw_rect(Rect2(0, size.y * t, size.x, size.y / 21.0 + 1.0), color)

	var aurora_colors := [Color(0.25, 0.92, 0.82, 0.12), Color(0.72, 0.88, 1.0, 0.10), Color(0.42, 0.78, 0.95, 0.08)]
	for index in range(3):
		var y := size.y * (0.12 + float(index) * 0.055)
		var points := PackedVector2Array([
			Vector2(-60.0, y + 34.0),
			Vector2(size.x * 0.28, y - 10.0),
			Vector2(size.x * 0.62, y + 18.0),
			Vector2(size.x + 80.0, y - 22.0),
			Vector2(size.x + 80.0, y + 34.0),
			Vector2(size.x * 0.58, y + 58.0),
			Vector2(size.x * 0.20, y + 30.0),
			Vector2(-60.0, y + 78.0),
		])
		draw_colored_polygon(points, aurora_colors[index])

	var far_ridge := Color(0.80, 0.93, 1.0, 0.22)
	var near_ridge := Color(0.94, 0.985, 1.0, 0.42)
	var shadow_color := Color(0.04, 0.16, 0.26, 0.25)
	var base_y := size.y * 0.30
	for index in range(8):
		var x := size.x * (float(index) / 6.0)
		var points := PackedVector2Array([
			Vector2(x - 220.0, base_y + 52.0),
			Vector2(x - 50.0, base_y - 48.0 - float(index % 2) * 26.0),
			Vector2(x + 150.0, base_y + 62.0),
		])
		draw_colored_polygon(points, far_ridge)
		draw_polyline(points, shadow_color, 2.0)

	for index in range(9):
		var x := size.x * (float(index) / 8.0)
		var points := PackedVector2Array([
			Vector2(x - 190.0, base_y + 132.0),
			Vector2(x - 30.0, base_y + 20.0 - float(index % 3) * 24.0),
			Vector2(x + 170.0, base_y + 132.0),
		])
		draw_colored_polygon(points, near_ridge)

	draw_rect(Rect2(0.0, size.y * 0.54, size.x, size.y * 0.46), Color(0.88, 0.96, 0.98, 0.50))
	draw_rect(Rect2(0.0, 0.0, size.x, size.y), Color(0.01, 0.04, 0.07, 0.10))
