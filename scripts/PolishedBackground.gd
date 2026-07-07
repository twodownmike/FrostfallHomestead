extends Control
class_name PolishedBackground

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
	var top := Color("#0b2035")
	var bottom := Color("#d9ecf2")
	draw_rect(Rect2(Vector2.ZERO, size), bottom)
	for index in range(16):
		var t := float(index) / 15.0
		var color := top.lerp(bottom, t)
		draw_rect(Rect2(0, size.y * t, size.x, size.y / 15.0 + 1.0), color)

	var ridge_color := Color(0.93, 0.98, 1.0, 0.34)
	var shadow_color := Color(0.12, 0.28, 0.42, 0.20)
	var base_y := size.y * 0.26
	for index in range(7):
		var x := size.x * (float(index) / 6.0)
		var points := PackedVector2Array([
			Vector2(x - 180.0, base_y + 40.0),
			Vector2(x - 50.0, base_y - 34.0 - float(index % 2) * 22.0),
			Vector2(x + 120.0, base_y + 52.0),
		])
		draw_colored_polygon(points, ridge_color)
		draw_polyline(points, shadow_color, 2.0)

	draw_rect(Rect2(0.0, size.y * 0.58, size.x, size.y * 0.42), Color(0.89, 0.96, 0.98, 0.38))
