extends Control

const GameStateScript := preload("res://scripts/GameState.gd")
const BackgroundScript := preload("res://scripts/PolishedBackground.gd")
const SnowOverlayScript := preload("res://scripts/SnowOverlay.gd")
const TILEMAP_TEXTURE := preload("res://assets/kenney_tiny_town/Tilemap/tilemap_packed.png")
const SKI_TEXTURE := preload("res://assets/kenney_tiny_ski/Tilemap/tilemap_packed.png")
const FONT_FUTURE := preload("res://assets/kenney_ui_pack/Font/Kenney Future.ttf")
const SPRITE_CITY_HALL_L1 := preload("res://assets/building_upgrades/city_hall_l1.png")
const SPRITE_CITY_HALL_L2 := preload("res://assets/building_upgrades/city_hall_l2.png")
const SPRITE_CITY_HALL_L3 := preload("res://assets/building_upgrades/city_hall_l3.png")
const SPRITE_HUNTERS_LODGE_L1 := preload("res://assets/building_upgrades/hunters_lodge_l1.png")
const SPRITE_HUNTERS_LODGE_L2 := preload("res://assets/building_upgrades/hunters_lodge_l2.png")
const SPRITE_HUNTERS_LODGE_L3 := preload("res://assets/building_upgrades/hunters_lodge_l3.png")
const SPRITE_SAWMILL_L1 := preload("res://assets/building_upgrades/sawmill_l1.png")
const SPRITE_SAWMILL_L2 := preload("res://assets/building_upgrades/sawmill_l2.png")
const SPRITE_SAWMILL_L3 := preload("res://assets/building_upgrades/sawmill_l3.png")
const SPRITE_COAL_MINE_L1 := preload("res://assets/building_upgrades/coal_mine_l1.png")
const SPRITE_COAL_MINE_L2 := preload("res://assets/building_upgrades/coal_mine_l2.png")
const SPRITE_COAL_MINE_L3 := preload("res://assets/building_upgrades/coal_mine_l3.png")
const SPRITE_SHELTERS_L1 := preload("res://assets/building_upgrades/shelters_l1.png")
const SPRITE_SHELTERS_L2 := preload("res://assets/building_upgrades/shelters_l2.png")
const SPRITE_SHELTERS_L3 := preload("res://assets/building_upgrades/shelters_l3.png")
const DETAIL_TIMBER := preload("res://assets/map_details/timber_forest_l1.png")
const DETAIL_STONE := preload("res://assets/map_details/stone_rocks_l1.png")
const DETAIL_HUNTING := preload("res://assets/map_details/hunting_tracks_l1.png")
const DETAIL_CAMP := preload("res://assets/map_details/camp_poi.png")
const DETAIL_CAVE := preload("res://assets/map_details/ice_cave.png")
const DETAIL_OUTPOST := preload("res://assets/map_details/outpost.png")
const DETAIL_ROAD_1 := preload("res://assets/map_details/road_snow_1.png")
const DETAIL_ROAD_2 := preload("res://assets/map_details/road_snow_2.png")
const ICON_HOME := preload("res://assets/kenney_game_icons/PNG/White/2x/home.png")
const ICON_WRENCH := preload("res://assets/kenney_game_icons/PNG/White/2x/wrench.png")
const ICON_TARGET := preload("res://assets/kenney_game_icons/PNG/White/2x/target.png")
const ICON_PLUS := preload("res://assets/kenney_game_icons/PNG/White/2x/plus.png")
const ICON_MINUS := preload("res://assets/kenney_game_icons/PNG/White/2x/minus.png")

const TILE_SIZE := 16
const TILE_SCALE := 3
const TILE_PIXEL := TILE_SIZE * TILE_SCALE
const WORLD_COLUMNS := 32
const WORLD_ROWS := 24
const BUILDING_SPRITES := {
	"cabin": [SPRITE_SHELTERS_L1, SPRITE_SHELTERS_L2, SPRITE_SHELTERS_L3],
	"woodlot": [SPRITE_SAWMILL_L1, SPRITE_SAWMILL_L2, SPRITE_SAWMILL_L3],
	"garden": [SPRITE_HUNTERS_LODGE_L1, SPRITE_HUNTERS_LODGE_L2, SPRITE_HUNTERS_LODGE_L3],
	"well": [SPRITE_CITY_HALL_L1, SPRITE_CITY_HALL_L2, SPRITE_CITY_HALL_L3],
	"workshop": [SPRITE_COAL_MINE_L1, SPRITE_COAL_MINE_L2, SPRITE_COAL_MINE_L3],
}
const RESOURCE_COLORS := {
	"food": Color("#f3b05a"),
	"wood": Color("#9b6a4a"),
	"water": Color("#55bde8"),
	"tools": Color("#d8e0e8"),
	"seed": Color("#90d06f"),
}
const MAP_DETAILS := [
	{"name": "Frozen Timber Stand", "texture": DETAIL_TIMBER, "cell": Vector2i(5, 5), "size": Vector2(116, 88), "message": "Timber stand marked. Future worker orders can harvest this area."},
	{"name": "Stone Outcrop", "texture": DETAIL_STONE, "cell": Vector2i(26, 5), "size": Vector2(98, 78), "message": "Stone outcrop scouted. This can support fortifications later."},
	{"name": "Hunting Trail", "texture": DETAIL_HUNTING, "cell": Vector2i(9, 18), "size": Vector2(112, 82), "message": "Fresh tracks found near the hunting trail."},
	{"name": "Abandoned Camp", "texture": DETAIL_CAMP, "cell": Vector2i(24, 18), "size": Vector2(118, 86), "message": "Abandoned camp logged as a point of interest."},
	{"name": "Ice Cave", "texture": DETAIL_CAVE, "cell": Vector2i(29, 13), "size": Vector2(130, 98), "message": "Ice cave discovered. Expedition hooks can use this later."},
	{"name": "Ridge Outpost", "texture": DETAIL_OUTPOST, "cell": Vector2i(4, 21), "size": Vector2(120, 86), "message": "Ridge outpost marked on the overworld map."},
	{"name": "Snow Road", "texture": DETAIL_ROAD_1, "cell": Vector2i(13, 13), "size": Vector2(104, 72), "message": "Road segment selected."},
	{"name": "Snow Road", "texture": DETAIL_ROAD_2, "cell": Vector2i(17, 13), "size": Vector2(104, 72), "message": "Road segment selected."},
]

var game: GameState
var resource_labels := {}
var building_rows := {}
var building_buttons := {}
var building_badges := {}
var map_tiles: Array[TextureButton] = []
var map_detail_buttons: Array[TextureButton] = []
var building_positions := {
	"cabin": Vector2i(14, 10),
	"woodlot": Vector2i(8, 8),
	"garden": Vector2i(20, 9),
	"well": Vector2i(14, 15),
	"workshop": Vector2i(21, 15),
}
var event_list: VBoxContainer
var world_grid: Control
var move_mode_button: Button
var map_status_label: Label
var day_label: Label
var season_label: Label
var workers_label: Label
var selected_title: Label
var selected_detail: Label
var selected_role: Label
var selected_risk: Label
var selected_output: Label
var condition_bar: ProgressBar
var readiness_bar: ProgressBar
var ability_list: HBoxContainer
var morale_bar: ProgressBar
var heat_bar: ProgressBar
var day_progress: ProgressBar
var selected_building := "cabin"
var ability_rebuild_queued := false
var world_rebuild_queued := false
var move_mode := false

func _ready() -> void:
	randomize()
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	game = GameStateScript.new()
	game.changed.connect(_refresh)
	_build_interface()
	_refresh()

func _process(delta: float) -> void:
	game.tick(delta)
	if day_progress != null:
		day_progress.value = 20.0 - game.seconds_until_day

func _build_interface() -> void:
	add_theme_font_override("font", FONT_FUTURE)

	var background: Control = BackgroundScript.new()
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var root := MarginContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("margin_left", 22)
	root.add_theme_constant_override("margin_top", 20)
	root.add_theme_constant_override("margin_right", 22)
	root.add_theme_constant_override("margin_bottom", 22)
	add_child(root)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 12)
	root.add_child(layout)

	layout.add_child(_build_top_hud())
	layout.add_child(_build_resource_strip())
	layout.add_child(_build_world_panel())
	layout.add_child(_build_action_bar())
	layout.add_child(_build_lower_panels())

func _build_top_hud() -> Control:
	var hud := PanelContainer.new()
	hud.add_theme_stylebox_override("panel", _panel_style(Color(0.04, 0.13, 0.22, 0.82), Color(0.62, 0.86, 1.0, 0.24), 8))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.add_theme_constant_override("margin_left", 0)
	hud.add_child(row)

	var title_box := VBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title_box)

	var title := Label.new()
	title.text = "Frostfall Homestead"
	title.add_theme_color_override("font_color", Color("#f7fbff"))
	title.add_theme_font_size_override("font_size", 30)
	title_box.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Winter settlement command"
	subtitle.add_theme_color_override("font_color", Color("#9fc5d7"))
	subtitle.add_theme_font_size_override("font_size", 14)
	title_box.add_child(subtitle)

	day_label = _make_chip()
	row.add_child(day_label)
	season_label = _make_chip()
	row.add_child(season_label)
	workers_label = _make_chip()
	row.add_child(workers_label)

	day_progress = ProgressBar.new()
	day_progress.min_value = 0
	day_progress.max_value = 20
	day_progress.custom_minimum_size = Vector2(180, 18)
	day_progress.add_theme_stylebox_override("background", _meter_background())
	day_progress.add_theme_stylebox_override("fill", _meter_fill(Color("#65c7f0")))
	row.add_child(day_progress)

	return hud

func _build_resource_strip() -> Control:
	var strip := HBoxContainer.new()
	strip.add_theme_constant_override("separation", 8)

	for resource_name in ["food", "wood", "water", "tools", "seed"]:
		var chip := PanelContainer.new()
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		chip.add_theme_stylebox_override("panel", _panel_style(Color(0.95, 0.99, 1.0, 0.88), Color(1, 1, 1, 0.42), 8))
		strip.add_child(chip)

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		chip.add_child(row)

		var swatch := ColorRect.new()
		swatch.color = RESOURCE_COLORS[resource_name]
		swatch.custom_minimum_size = Vector2(8, 36)
		row.add_child(swatch)

		var label := Label.new()
		label.add_theme_color_override("font_color", Color("#153247"))
		label.add_theme_font_size_override("font_size", 17)
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		resource_labels[resource_name] = label
		row.add_child(label)

	return strip

func _build_world_panel() -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.08, 0.20, 0.30, 0.72), Color(0.84, 0.97, 1.0, 0.34), 8))

	var stack := Control.new()
	stack.custom_minimum_size = Vector2(0, 500)
	panel.add_child(stack)

	var content := VBoxContainer.new()
	content.set_anchors_preset(Control.PRESET_FULL_RECT)
	content.add_theme_constant_override("separation", 8)
	stack.add_child(content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	content.add_child(header)

	selected_title = Label.new()
	selected_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	selected_title.add_theme_color_override("font_color", Color("#f8fcff"))
	selected_title.add_theme_font_size_override("font_size", 24)
	header.add_child(selected_title)

	selected_detail = Label.new()
	selected_detail.add_theme_color_override("font_color", Color("#bde3f3"))
	selected_detail.add_theme_font_size_override("font_size", 15)
	header.add_child(selected_detail)

	move_mode_button = _make_action_button("Move: Off", ICON_TARGET, Callable(self, "_toggle_move_mode"), Color("#425f75"))
	move_mode_button.custom_minimum_size = Vector2(150, 44)
	header.add_child(move_mode_button)

	map_status_label = Label.new()
	map_status_label.add_theme_color_override("font_color", Color("#f1c684"))
	map_status_label.add_theme_font_size_override("font_size", 13)
	map_status_label.text = "Drag the map to pan. Toggle Move to relocate buildings."
	content.add_child(map_status_label)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 390)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(scroll)

	world_grid = Control.new()
	world_grid.custom_minimum_size = Vector2(WORLD_COLUMNS * TILE_PIXEL, WORLD_ROWS * TILE_PIXEL)
	scroll.add_child(world_grid)
	_build_world_grid(world_grid)

	content.add_child(_build_selected_inspector())

	var snow: Control = SnowOverlayScript.new()
	snow.set_anchors_preset(Control.PRESET_FULL_RECT)
	stack.add_child(snow)

	return panel

func _build_selected_inspector() -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.03, 0.11, 0.17, 0.78), Color(0.77, 0.94, 1.0, 0.26), 8))

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var info_row := HBoxContainer.new()
	info_row.add_theme_constant_override("separation", 12)
	box.add_child(info_row)

	var text_stack := VBoxContainer.new()
	text_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_row.add_child(text_stack)

	selected_role = Label.new()
	selected_role.add_theme_color_override("font_color", Color("#edf9ff"))
	selected_role.add_theme_font_size_override("font_size", 15)
	text_stack.add_child(selected_role)

	selected_output = Label.new()
	selected_output.add_theme_color_override("font_color", Color("#9fd8ed"))
	selected_output.add_theme_font_size_override("font_size", 14)
	text_stack.add_child(selected_output)

	selected_risk = Label.new()
	selected_risk.add_theme_color_override("font_color", Color("#f1c684"))
	selected_risk.add_theme_font_size_override("font_size", 13)
	selected_risk.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_stack.add_child(selected_risk)

	condition_bar = _make_named_meter("Condition", Color("#75d4d0"))
	info_row.add_child(condition_bar)
	readiness_bar = _make_named_meter("Order Ready", Color("#7cc8ff"))
	info_row.add_child(readiness_bar)

	ability_list = HBoxContainer.new()
	ability_list.add_theme_constant_override("separation", 8)
	box.add_child(ability_list)

	return panel

func _build_action_bar() -> Control:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 10)
	bar.add_child(_make_action_button("Repair Hearth", ICON_WRENCH, Callable(game, "repair_hearth"), Color("#1f87b5")))
	bar.add_child(_make_action_button("Send Expedition", ICON_TARGET, Callable(game, "send_expedition"), Color("#356b5f")))

	morale_bar = _make_named_meter("Morale", Color("#77d37b"))
	bar.add_child(morale_bar)
	heat_bar = _make_named_meter("Hearth", Color("#f0a44a"))
	bar.add_child(heat_bar)

	return bar

func _build_lower_panels() -> Control:
	var lower := HBoxContainer.new()
	lower.size_flags_vertical = Control.SIZE_EXPAND_FILL
	lower.add_theme_constant_override("separation", 12)

	var buildings_panel := PanelContainer.new()
	buildings_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	buildings_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.96, 0.99, 1.0, 0.92), Color(1, 1, 1, 0.48), 8))
	lower.add_child(buildings_panel)

	var building_list := VBoxContainer.new()
	building_list.add_theme_constant_override("separation", 8)
	buildings_panel.add_child(building_list)

	var building_heading := Label.new()
	building_heading.text = "Homestead Operations"
	building_heading.add_theme_color_override("font_color", Color("#16354b"))
	building_heading.add_theme_font_size_override("font_size", 21)
	building_list.add_child(building_heading)

	for building_id in game.buildings.keys():
		var row := _make_building_row(building_id)
		building_rows[building_id] = row
		building_list.add_child(row["container"])

	var log_panel := PanelContainer.new()
	log_panel.custom_minimum_size = Vector2(340, 0)
	log_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.05, 0.14, 0.22, 0.80), Color(0.71, 0.91, 1.0, 0.28), 8))
	lower.add_child(log_panel)

	var log_box := VBoxContainer.new()
	log_box.add_theme_constant_override("separation", 8)
	log_panel.add_child(log_box)

	var log_heading := Label.new()
	log_heading.text = "Dispatch Log"
	log_heading.add_theme_color_override("font_color", Color("#eef9ff"))
	log_heading.add_theme_font_size_override("font_size", 21)
	log_box.add_child(log_heading)

	event_list = VBoxContainer.new()
	event_list.add_theme_constant_override("separation", 6)
	log_box.add_child(event_list)

	return lower

func _build_world_grid(world_grid: Control) -> void:
	building_buttons.clear()
	building_badges.clear()
	map_tiles.clear()
	map_detail_buttons.clear()
	var terrain := _make_terrain()

	for y in range(WORLD_ROWS):
		for x in range(WORLD_COLUMNS):
			var position := Vector2i(x, y)
			var tile := TextureButton.new()
			tile.position = Vector2(x * TILE_PIXEL, y * TILE_PIXEL)
			tile.custom_minimum_size = Vector2(TILE_PIXEL, TILE_PIXEL)
			tile.size = Vector2(TILE_PIXEL, TILE_PIXEL)
			tile.stretch_mode = TextureButton.STRETCH_SCALE
			tile.texture_normal = _terrain_texture(terrain[y][x])
			tile.modulate = Color("#dceef2") if terrain[y][x] == 0 else Color.WHITE
			tile.disabled = not move_mode
			tile.pressed.connect(_handle_map_cell_pressed.bind(position))
			map_tiles.append(tile)
			world_grid.add_child(tile)

	for detail in MAP_DETAILS:
		_add_map_detail(world_grid, detail)

	for building_id in building_positions.keys():
		_add_building_sprite(world_grid, building_id)

func _add_map_detail(board: Control, detail: Dictionary) -> void:
	var cell: Vector2i = detail["cell"]
	var detail_size: Vector2 = detail["size"]
	var detail_texture: Texture2D = detail["texture"]
	var detail_name: String = detail["name"]
	var detail_message: String = detail["message"]
	var center := Vector2(cell.x * TILE_PIXEL + TILE_PIXEL * 0.5, cell.y * TILE_PIXEL + TILE_PIXEL * 0.5)
	var button := TextureButton.new()
	button.position = center - detail_size * 0.5
	button.custom_minimum_size = detail_size
	button.size = detail_size
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.texture_normal = detail_texture
	button.tooltip_text = detail_name
	button.pressed.connect(_handle_map_detail_pressed.bind(detail_message))
	button.z_index = 1
	map_detail_buttons.append(button)
	board.add_child(button)

func _add_building_sprite(board: Control, building_id: String) -> void:
	var texture: Texture2D = _building_texture(building_id)
	var level := int(game.buildings[building_id]["level"])
	var visual_tier := mini(level - 1, 2)
	var sprite_size: Vector2 = Vector2(120, 92) + Vector2(24, 18) * float(visual_tier)
	var plot: Vector2i = building_positions[building_id]
	var center := Vector2(plot.x * TILE_PIXEL + TILE_PIXEL * 0.5, plot.y * TILE_PIXEL + TILE_PIXEL * 0.5)

	var button := TextureButton.new()
	button.position = center - sprite_size * 0.5
	button.custom_minimum_size = sprite_size
	button.size = sprite_size
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.texture_normal = texture
	button.tooltip_text = game.buildings[building_id]["name"]
	button.pressed.connect(_select_building.bind(building_id))
	button.z_index = 3
	building_buttons[building_id] = button
	board.add_child(button)

	var badge := Label.new()
	badge.text = "READY"
	badge.position = button.position + Vector2(sprite_size.x * 0.28, sprite_size.y - 20)
	badge.custom_minimum_size = Vector2(sprite_size.x * 0.44, 18)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.add_theme_color_override("font_color", Color("#0b2534"))
	badge.add_theme_font_size_override("font_size", 9)
	badge.add_theme_stylebox_override("normal", _badge_style())
	badge.z_index = 4
	building_badges[building_id] = badge
	board.add_child(badge)

func _make_terrain() -> Array:
	var terrain := []
	for y in range(WORLD_ROWS):
		var row := []
		for x in range(WORLD_COLUMNS):
			var tile_id := 0
			if x == 14 or y == 13:
				tile_id = 2
			elif x in [18, 19, 20, 21, 22] and y in [10, 11, 12, 13]:
				tile_id = 3
			elif (x + y) % 9 == 0:
				tile_id = 1
			row.append(tile_id)
		terrain.append(row)

	for tree_position in [Vector2i(2, 2), Vector2i(5, 4), Vector2i(25, 3), Vector2i(28, 7), Vector2i(6, 18), Vector2i(27, 20)]:
		terrain[tree_position.y][tree_position.x] = 10

	for fence_position in [Vector2i(11, 12), Vector2i(12, 12), Vector2i(13, 12), Vector2i(18, 14), Vector2i(19, 14), Vector2i(20, 14)]:
		terrain[fence_position.y][fence_position.x] = 70

	return terrain

func _terrain_texture(tile_id: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	if tile_id == 0 or tile_id == 1:
		atlas.atlas = SKI_TEXTURE
		atlas.region = Rect2((tile_id % 12) * TILE_SIZE, int(tile_id / 12) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
	else:
		atlas.atlas = TILEMAP_TEXTURE
		atlas.region = Rect2((tile_id % 12) * TILE_SIZE, int(tile_id / 12) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
	return atlas

func _select_building(building_id: String) -> void:
	selected_building = building_id
	_refresh()

func _toggle_move_mode() -> void:
	move_mode = not move_mode
	move_mode_button.text = "Move: On" if move_mode else "Move: Off"
	map_status_label.text = "Move mode: tap an open snow tile to place %s." % game.buildings[selected_building]["name"] if move_mode else "Drag the map to pan. Toggle Move to relocate buildings."
	_set_map_tiles_enabled(move_mode)

func _handle_map_cell_pressed(cell: Vector2i) -> void:
	if not move_mode:
		return
	if _is_occupied(cell):
		game.add_log("That tile is already occupied.")
		return

	building_positions[selected_building] = cell
	move_mode = false
	move_mode_button.text = "Move: Off"
	_set_map_tiles_enabled(false)
	map_status_label.text = "%s moved to a new plot." % game.buildings[selected_building]["name"]
	game.add_log("%s relocated to plot %s,%s." % [game.buildings[selected_building]["name"], cell.x, cell.y])
	_queue_world_rebuild()

func _handle_map_detail_pressed(message: String) -> void:
	if move_mode:
		return
	game.add_log(message)

func _is_occupied(cell: Vector2i) -> bool:
	for position in building_positions.values():
		if position == cell:
			return true
	return false

func _set_map_tiles_enabled(enabled: bool) -> void:
	for tile in map_tiles:
		if is_instance_valid(tile):
			tile.disabled = not enabled

func _building_texture(building_id: String) -> Texture2D:
	var level := int(game.buildings[building_id]["level"])
	var options: Array = BUILDING_SPRITES[building_id]
	var index: int = clampi(level - 1, 0, options.size() - 1)
	return options[index]

func _queue_world_rebuild() -> void:
	if world_rebuild_queued:
		return
	world_rebuild_queued = true
	call_deferred("_rebuild_world_grid")

func _rebuild_world_grid() -> void:
	world_rebuild_queued = false
	for child in world_grid.get_children():
		child.hide()
		child.queue_free()
	call_deferred("_build_world_grid", world_grid)

func _make_building_row(building_id: String) -> Dictionary:
	var row_panel := PanelContainer.new()
	row_panel.add_theme_stylebox_override("panel", _panel_style(Color(1, 1, 1, 0.76), Color(0.55, 0.73, 0.84, 0.24), 6))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row_panel.add_child(row)

	var icon := TextureRect.new()
	icon.texture = ICON_HOME
	icon.modulate = Color("#1a516c")
	icon.custom_minimum_size = Vector2(30, 30)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)

	var info := Label.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_theme_color_override("font_color", Color("#153247"))
	info.add_theme_font_size_override("font_size", 15)
	row.add_child(info)

	var minus := _make_icon_button(ICON_MINUS, func() -> void: game.assign_worker(building_id, -1))
	row.add_child(minus)

	var plus := _make_icon_button(ICON_PLUS, func() -> void: game.assign_worker(building_id, 1))
	row.add_child(plus)

	var upgrade := _make_icon_button(ICON_WRENCH, func() -> void: game.upgrade(building_id))
	row.add_child(upgrade)

	return {
		"container": row_panel,
		"info": info,
		"minus": minus,
		"plus": plus,
		"upgrade": upgrade,
	}

func _refresh() -> void:
	day_label.text = "DAY %s" % game.day
	season_label.text = game.season.to_upper()
	workers_label.text = "IDLE %s/%s" % [game.available_workers, game.homesteaders]
	day_progress.value = 20.0 - game.seconds_until_day
	morale_bar.value = game.morale
	heat_bar.value = game.heat

	for resource_name in resource_labels.keys():
		resource_labels[resource_name].text = "%s\n%s" % [resource_name.capitalize(), int(game.resources[resource_name])]

	var selected: Dictionary = game.buildings[selected_building]
	selected_title.text = "%s Command" % selected["name"]
	selected_detail.text = "L%s  |  Workers %s/%s  |  Ready %s%%" % [
		selected["level"],
		selected["workers"],
		selected["max_workers"],
		int(selected["readiness"]),
	]
	var details := game.building_details(selected_building)
	selected_role.text = details["role"]
	selected_output.text = "%s | %s" % [details["output"], _format_production(game.production_preview(selected_building))]
	selected_risk.text = details["risk"]
	condition_bar.value = selected["condition"]
	readiness_bar.value = selected["readiness"]
	_queue_ability_rebuild()

	for building_id in building_rows.keys():
		var building: Dictionary = game.buildings[building_id]
		var cost := game.upgrade_cost(building_id)
		var row: Dictionary = building_rows[building_id]
		var prefix := "> " if building_id == selected_building else ""
		row["info"].text = "%s%s  L%s\n%s/%s assigned | %s%% condition | Upgrade %s wood, %s tools" % [
			prefix,
			building["name"],
			building["level"],
			building["workers"],
			building["max_workers"],
			int(building["condition"]),
			cost["wood"],
			cost["tools"],
		]
		row["plus"].disabled = game.available_workers <= 0 or building["workers"] >= building["max_workers"]
		row["minus"].disabled = building["workers"] <= 0
		row["upgrade"].disabled = not game.can_upgrade(building_id)

	for building_id in building_buttons.keys():
		var button: TextureButton = building_buttons[building_id]
		var building: Dictionary = game.buildings[building_id]
		var badge: Label = building_badges[building_id]
		button.texture_normal = _building_texture(building_id)
		button.tooltip_text = "%s | Ready %s%% | Condition %s%%" % [
			building["name"],
			int(building["readiness"]),
			int(building["condition"]),
		]
		badge.visible = building["readiness"] >= 100.0
		if building_id == selected_building:
			button.modulate = Color(1.55, 1.55, 1.55)
		elif building["readiness"] >= 100.0:
			button.modulate = Color("#d8fff1")
		else:
			button.modulate = Color(0.95, 1.0, 1.04)

	for child in event_list.get_children():
		child.queue_free()

	for event_text in game.event_log:
		var event_label := Label.new()
		event_label.text = event_text
		event_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		event_label.add_theme_color_override("font_color", Color("#d8edf7"))
		event_label.add_theme_font_size_override("font_size", 14)
		event_list.add_child(event_label)

func _queue_ability_rebuild() -> void:
	if ability_rebuild_queued:
		return

	ability_rebuild_queued = true
	call_deferred("_rebuild_ability_buttons")

func _rebuild_ability_buttons() -> void:
	ability_rebuild_queued = false
	for child in ability_list.get_children():
		child.hide()
		child.queue_free()

	for action in game.building_actions(selected_building):
		var action_id: String = action["id"]
		var button := _make_action_button(
			"%s\n%s\n%s" % [action["name"], action["cost"], action["effect"]],
			ICON_TARGET,
			_perform_selected_action.bind(action_id),
			Color("#1f6f94")
		)
		button.custom_minimum_size = Vector2(210, 74)
		button.disabled = not game.can_perform_building_action(selected_building, action_id)
		ability_list.add_child(button)

	var upgrade_cost := game.upgrade_cost(selected_building)
	var upgrade := _make_action_button(
		"Upgrade\n%s wood, %s tools\n+level, +capacity" % [upgrade_cost["wood"], upgrade_cost["tools"]],
		ICON_WRENCH,
		func() -> void: game.upgrade(selected_building),
		Color("#a36a25")
	)
	upgrade.custom_minimum_size = Vector2(210, 74)
	upgrade.disabled = not game.can_upgrade(selected_building)
	ability_list.add_child(upgrade)

func _format_production(production: Dictionary) -> String:
	var parts: Array[String] = []
	for key in production.keys():
		parts.append("+%s %s/day" % [snappedf(production[key], 0.1), key])
	return ", ".join(parts)

func _perform_selected_action(action_id: String) -> void:
	game.perform_building_action(selected_building, action_id)

func _make_chip() -> Label:
	var label := Label.new()
	label.custom_minimum_size = Vector2(116, 40)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color("#f2fbff"))
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_stylebox_override("normal", _panel_style(Color(0.10, 0.27, 0.39, 0.82), Color(0.75, 0.93, 1.0, 0.22), 6))
	return label

func _make_action_button(text: String, icon: Texture2D, callback: Callable, color: Color) -> Button:
	var button := Button.new()
	button.text = text
	button.icon = icon
	button.expand_icon = true
	button.custom_minimum_size = Vector2(220, 52)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_stylebox_override("normal", _panel_style(color, Color(1, 1, 1, 0.24), 8))
	button.add_theme_stylebox_override("hover", _panel_style(color.lightened(0.12), Color(1, 1, 1, 0.34), 8))
	button.add_theme_stylebox_override("pressed", _panel_style(color.darkened(0.10), Color(1, 1, 1, 0.18), 8))
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_font_size_override("font_size", 16)
	button.pressed.connect(callback)
	return button

func _make_icon_button(icon: Texture2D, callback: Callable) -> Button:
	var button := Button.new()
	button.icon = icon
	button.expand_icon = true
	button.custom_minimum_size = Vector2(46, 42)
	button.add_theme_stylebox_override("normal", _panel_style(Color("#1d6d93"), Color(1, 1, 1, 0.20), 6))
	button.add_theme_stylebox_override("hover", _panel_style(Color("#2588b4"), Color(1, 1, 1, 0.28), 6))
	button.add_theme_stylebox_override("pressed", _panel_style(Color("#165675"), Color(1, 1, 1, 0.18), 6))
	button.pressed.connect(callback)
	return button

func _make_named_meter(label_text: String, fill_color: Color) -> ProgressBar:
	var meter := ProgressBar.new()
	meter.min_value = 0
	meter.max_value = 100
	meter.show_percentage = true
	meter.tooltip_text = label_text
	meter.custom_minimum_size = Vector2(150, 52)
	meter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	meter.add_theme_stylebox_override("background", _meter_background())
	meter.add_theme_stylebox_override("fill", _meter_fill(fill_color))
	meter.add_theme_color_override("font_color", Color("#f7fbff"))
	return meter

func _panel_style(bg: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 12
	style.content_margin_top = 10
	style.content_margin_right = 12
	style.content_margin_bottom = 10
	style.shadow_color = Color(0.0, 0.05, 0.10, 0.24)
	style.shadow_size = 8
	style.shadow_offset = Vector2(0, 4)
	return style

func _meter_background() -> StyleBoxFlat:
	return _panel_style(Color(0.04, 0.11, 0.17, 0.72), Color(0.70, 0.90, 1.0, 0.18), 6)

func _meter_fill(fill_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.set_corner_radius_all(6)
	return style

func _badge_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#9ff0ff")
	style.border_color = Color(1, 1, 1, 0.55)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 4
	style.content_margin_right = 4
	style.content_margin_top = 1
	style.content_margin_bottom = 1
	return style
