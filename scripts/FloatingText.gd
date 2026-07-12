extends Control

var _velocity := Vector2(0, -42)
var _life := 1.15
var _label: Label

static func spawn(parent: Node, global_pos: Vector2, text: String, color: Color = Color("#9ff0c8")) -> void:
	var script: GDScript = load("res://scripts/FloatingText.gd") as GDScript
	var ft: Control = script.new() as Control
	parent.add_child(ft)
	ft.call("_setup", global_pos, text, color)

func _setup(global_pos: Vector2, text: String, color: Color) -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 80
	_label = Label.new()
	_label.text = text
	_label.add_theme_color_override("font_color", color)
	_label.add_theme_font_size_override("font_size", 15)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_label)
	global_position = global_pos - Vector2(40, 10)
	_label.custom_minimum_size = Vector2(80, 20)

func _process(delta: float) -> void:
	position += _velocity * delta
	_life -= delta
	modulate.a = clampf(_life / 0.4, 0.0, 1.0)
	if _life <= 0.0:
		queue_free()
