extends Control

## Stylized central campfire for Whiteout-style city heart.

var _t := 0.0
var heat_ratio := 0.7

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(96, 96)
	set_process(true)

func set_heat(ratio: float) -> void:
	heat_ratio = clampf(ratio, 0.05, 1.0)

func _process(delta: float) -> void:
	_t += delta
	queue_redraw()

func _draw() -> void:
	var c := size * 0.5
	# Soft glow on snow
	var glow_a := 0.12 + heat_ratio * 0.18
	draw_circle(c + Vector2(0, 10), 48.0, Color(1.0, 0.55, 0.15, glow_a * 0.5))
	draw_circle(c + Vector2(0, 8), 32.0, Color(1.0, 0.7, 0.25, glow_a))

	# Log pile
	var log_col := Color("#5a3a22")
	var log_hi := Color("#7a5230")
	draw_colored_polygon(PackedVector2Array([
		c + Vector2(-28, 18), c + Vector2(26, 10), c + Vector2(30, 22), c + Vector2(-24, 28),
	]), log_col)
	draw_colored_polygon(PackedVector2Array([
		c + Vector2(-22, 8), c + Vector2(20, 16), c + Vector2(18, 26), c + Vector2(-26, 18),
	]), log_hi)

	# Flame body
	var flick := sin(_t * 9.0) * 3.0 + cos(_t * 13.0) * 2.0
	var h := 28.0 + heat_ratio * 22.0 + flick
	var flame_orange := Color(1.0, 0.45, 0.08, 0.92)
	var flame_yellow := Color(1.0, 0.85, 0.25, 0.95)
	var flame_core := Color(1.0, 0.95, 0.75, 0.98)
	var base_y := c.y + 6.0
	draw_colored_polygon(PackedVector2Array([
		Vector2(c.x - 16, base_y),
		Vector2(c.x - 8 + flick * 0.3, base_y - h * 0.55),
		Vector2(c.x + flick * 0.2, base_y - h),
		Vector2(c.x + 10 - flick * 0.2, base_y - h * 0.5),
		Vector2(c.x + 18, base_y),
	]), flame_orange)
	draw_colored_polygon(PackedVector2Array([
		Vector2(c.x - 10, base_y - 2),
		Vector2(c.x - 4, base_y - h * 0.45),
		Vector2(c.x + flick * 0.15, base_y - h * 0.78),
		Vector2(c.x + 6, base_y - h * 0.4),
		Vector2(c.x + 12, base_y - 2),
	]), flame_yellow)
	draw_colored_polygon(PackedVector2Array([
		Vector2(c.x - 5, base_y - 4),
		Vector2(c.x + flick * 0.1, base_y - h * 0.5),
		Vector2(c.x + 5, base_y - 4),
	]), flame_core)

	# Sparks
	for i in 5:
		var a := _t * (2.5 + i * 0.4) + i * 1.7
		var sp := Vector2(sin(a) * (6 + i * 2), -18 - fmod(_t * (20 + i * 8) + i * 13, 30.0))
		draw_circle(c + sp, 1.2 + (i % 2), Color(1.0, 0.9, 0.4, 0.5 + heat_ratio * 0.3))
